#!/bin/bash
# Required scripts: func.temp
# Required environment var: ADMIT
# Description: mark '#' if the line with own name is found in authorized_keys,
#   maching own id_rsa.pub and the line, otherwise move older one to invalid_keys
. func.temp
. func.attr
ATH=authorized_keys
INV=invalid_keys
SEC=~/.ssh/id_rsa
PUB=~/.ssh/id_rsa.pub
CFG=~/.ssh/config
LATH=~/.ssh/$ATH
LINV=~/.ssh/$INV
## For manipulating authorized_keys (can be reduced -> _overwrite)
#link auth-mark
_auth-mark(){ # Mark '#' for own old pubkey [authorized_keys] (You can manualy set)
    local ath=${1:-$LATH}
    local pub=$PUB
    [ -f $ath -a -f $pub ] || _abort "No ssh files"
    local rsa mykey me tath pre key host
    read rsa mykey me < $pub
    _temp tath
    grep -v $mykey $ath|\
        while read pre key host; do
            [ "$host" = "$me" ] && echo -n '#'
           echo "$pre $key $host"
        done > $tath
    sort -u $pub $tath | _overwrite $ath && _warn "Invalid keys are marked"
}
#link auth-rginv
_auth-rginv(){ # Register Invalid Keys [authorized_keys] [invalid_keys]
    local ath=${1:-$LATH}
    local inv=${2:-$LINV}
    # Split file into invalid_keys by #headed line
    local tinv
    _temp tinv
    grep '^.\{32\}$' $inv > $tinv
    ## For invalid_keys (increase only -> merge)
    grep "^#" $ath |\
        while read line;do
            md5sum <<< ${line#*#} | cut -c-32
        done >> $tinv
    sort -u $tinv | _overwrite $inv && _warn "invalid_key was updated"
    grep -v "^#" $ath | _overwrite $ath && _warn "authorized_keys was updated (rm #)"
}
#link auth-rminv
_auth-rminv(){
    local ath=${1:-$LATH}
    local inv=${2:-$LINV}
    #  exculde invalid keys
    while read line;do
        if md="$(grep $(md5sum <<< $line | cut -c-32) $inv)"; then
            _warn "Remove Invalid Key for ${line##* } ($md)"
        else
            echo "$line"
        fi
    done < $ath | _overwrite $ath && _warn "authorized_keys was updated (rm inv)"
}
#link auth-rmdup
_auth-rmdup(){ # Remove dup key [authorized_keys] [invalid_keys]
    local ath=${1:-$LATH} list dup rsa key host
    #  remove duplicated keys (compare key without host)
    while read rsa key host;do
        if [ "$pkey" = "$key" ]; then
            dup=1
        else
            [ "$pkey" ] && echo "${list// /,}"
            [ "$dup" ] && _warn "Put Together Duplicated Key (${list// /,})"
            unset list dup
            [ "$rsa" = ssh-rsa ] && echo -n "$rsa $key "
        fi
        if [ "$host" ] ; then
            _add_list list ${host//,/ }
        fi
        pkey=$key
    done < <(sort $ath;echo) | _overwrite $ath && _warn "authorized_keys was updated (rm dup)"
}
#link auth-trim
_auth-trim(){
    _auth-mark $*
    _auth-rginv $*
    _auth-rminv $*
    _auth-rmdup $*
}
#link auth-mates
_auth-mates(){ # List the mate accounts in authorized_keys
    grep -v '^#' $LATH|\
        cut -d' ' -f3|\
        tr , $'\n'|\
        grep @|\
        grep -v $(cut -d' ' -f3 $PUB)
}
#link auth-perm
_auth-perm(){ # Set ssh related file permission
    _setp 755 ~
    [ -d ~/.ssh ] || exit
    _warn "Correcting permission for ssh files"
    cd ~/.ssh
    _setp 700 .
    _setp 600 id_rsa gpgpass
    _setp 644 !(id_rsa|gpgpass)
}
_ssh-setup(){ # Setup ssh
    type ssh > /dev/null || _abort "No ssh installed"
    [ -e $SEC ] || ssh-keygen
    [ -e $PUB ] || ssh-keygen -y -f $SEC > $PUB
    [ -e $LINV ] || touch $LINV
    [ -e $LATH ] || cp $PUB $LATH
    grep -q "$(< $PUB)" $LATH || grep . $PUB >> $LATH
}

### For remote operation ###
[ -d ~/.var/ssh/admit ] || mkdir -p ~/.var/ssh/admit
[ -d ~/.var/ssh/impose ] || mkdir -p ~/.var/ssh/impose
_sshopt(){ # Set rhost,sshopt,port
    [[ "$1" =~ @ ]] || _abort "Not user@host"
    local host user
    IFS=:;set - $1;rhost=$1;port=$2
    IFS=@;set - $1;user=$1;host=$2
    unset IFS
    [[ "$host" =~ (`hostname`|localhost) ]] && [ "$user" = $LOGNAME ] && { _warn "Self push"; return 1; }
    sshopt="-o StrictHostKeyChecking=no ${port:+-P $port}"
}
#link rem-fetch
_rem-fetch(){ # Fetch and merge auth key (user@host:port)
    _sshopt $1 || return 1
    _warn "Host $rhost${port:+:$port}"
    # Get files from remote
    cd ~/.var/ssh
    scp $sshopt $rhost:.ssh/$ATH $rhost:.ssh/$INV  .
    [ -s $ATH ] && mv $ATH $ATH.$rhost
    [ -s $INV ] && mv $INV $INV.$rhost
}
#link rem-push
_rem-push(){
    _sshopt $1 || return 1
    local send i
    if [ -s $ATH -a -s $ATH.$rhost ];then
        cmp -s $ATH $ATH.$rhost || send=$ATH
    fi
    if [ -s $INV -a -s $INV.$rhost ];then
        cmp -s $INV $INV.$rhost || send="$send $INV"
    fi
    if [ "$send" ] ; then
        scp -pq $sshopt $send $rhost:.ssh/ &&\
        for i in $send;do
            _warn "$i($(stat -c%s $i)) is updated at $rhost"
        done
    fi
}
_rem-admit(){
    # Merge with local file
    cd ~/.var/ssh/admit/
    mv ../*.* .
    grep -h . $LATH $ATH.* >> $ATH
    grep -h . $LINV $INV.* >> $INV
    _auth-trim $ATH $INV >/dev/null
    _overwrite $LINV < $INV
    _overwrite $LATH < $ATH
}
_rem-impose(){
    # Merge with local file
    cd ~/.var/ssh/impose/
    mv ../*.$rhost .
    # Conceal group members
    cut -d' ' -f1-2 $LATH > $ATH
    grep -h . $ATH.$rhost >> $ATH
    _auth-trim $ATH $INV.$rhost >/dev/null
}
#link rem-valid
_rem-valid(){
    local i 
    for i; do
        ssh -q\
            -o "BatchMode=yes"\
            -o "ConnectTimeout=1"\
            -o "StrictHostKeyChecking=no"\
            $i : && echo $i
    done
}
_chkfunc $*
