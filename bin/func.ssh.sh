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
RATH=~/.var/$ATH
RINV=~/.var/$INV
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
#link auth-setinv
_auth-setinv(){ # Set Invalid Keys [authorized_keys] [invalid_keys]
    local ath=${1:-$LATH}
    local inv=${2:-$LINV}
    # Split file into invalid_keys by #headed line
    local tinv
    _temp tinv
    cp $inv $tinv
    ## For invalid_keys (increase only -> merge)
    grep "^#" $ath |\
        while read line;do
            md5sum <<< $line | cut -c-32
        done >> $tinv
    sort -u $tinv | _overwrite $inv
    grep -v "^#" $ath | sort -r | _overwrite $ath
}
#link auth-rmdup
_auth-rmdup(){ # Remove dup key [authorized_keys] [invalid_keys]
    local ath=${1:-$LATH} tlist pkey phost
    _temp tlist
    #  remove duplicated keys (compare key without host)
    while read rsa key host;do
        if [ "$pkey" = "$key" ]; then
            echo $phost >> $tlist
        elif [ -s $tlist ]; then
            echo $phost >> $tlist
            local csv=$(sort -u $tlist|_list_csv)
            _warn "Remove Duplicated Key ($csv)"
            echo "$rsa $pkey $csv"
            > $tlist
        elif [ "$pkey" ]; then
            echo "$rsa $pkey $phost"
        fi
        pkey=$key
        phost=$host
    done < <(sort $ath;echo)| _overwrite $ath
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
    done < $ath | _overwrite $ath && _warn "authorized_key was updated"
}
#link auth-trim
_auth-trim(){
    _auth-setinv $*
    _auth-rmdup $*
    _auth-rminv $*
}
#link auth-mates
_auth-mates(){ # List the mate accounts in authorized_keys
    cut -d' ' -f3 $LATH|grep @|grep -v $(cut -d' ' -f3 $PUB)
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
    grep -q "$(< $PUB)" $LATH || cat $PUB >> $LATH
}
_sshopt(){ # Set rhost,sshopt,port
    IFS=:;set - $1;rhost=$1;port=$2;unset IFS
    [[ "$rhost" =~ (`hostname`|localhost) ]] && { _warn "Self push"; return 1; }
    sshopt="-o StrictHostKeyChecking=no ${port:+-P $port}"
}
_rem-fetch(){ # Fetch and merge auth key (user@host:port)
    _sshopt $1 || return 1
    _warn "Host $rhost${port:+:$port}"
    # Get files from remote
    scp $sshopt $rhost:.ssh/$ATH $rhost:.ssh/$INV  ~/.var
    mv $RATH $RATH.$rhost
    mv $RINV $RINV.$rhost
}
_rem-push(){
    _sshopt $1 || return 1
    local send i
    cmp -s $RATH $RATH.$rhost || send=$RATH
    cmp -s $RINV $RINV.$rhost || send="$send $RINV"
    if [ "$send" ] ; then
        scp -pq $sshopt $send $rhost:.ssh/
        for i in $send;do
            _warn "$i($(stat -c%s $i)) is updated at $rhost"
        done
    fi
}
_rem-trim(){
    # Merge with local file
    cat $LINV $RINV.* > $RINV
    if [ "$ADMIT" ] ; then
        cp $LATH $RATH
    else
        cut -d' ' -f1-2 $LATH > $RATH
    fi
    cat $RATH.* >> $RATH
    _auth-mark $RATH
    _auth-trim $RATH $RINV >/dev/null
    if [ "$ADMIT" ] ; then
        _overwrite $LATH < $RATH
        cp $RATH $RATH.admit
    else
        cp $RATH $RATH.inpose
    fi
    _overwrite $LINV < $RINV
}
#link ssh-push-inv
_auth-push-inv(){
    _sshopt $1 || return 1
    scp -pq $sshopt $LINV $rhost:$INV
}
_chkfunc $*
