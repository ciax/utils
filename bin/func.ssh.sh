#!/bin/bash
# Required scripts: func.temp
# Description: Mark '#' at the head of a line in authorized_keys to reserve for registration to the invalid_keys.
. func.list
ATH=authorized_keys
INV=invalid_keys
SEC=~/.ssh/id_rsa
PUB=~/.ssh/id_rsa.pub
CFG=~/.ssh/config
LATH=~/.ssh/$ATH
LINV=~/.ssh/$INV
SSHVAR=~/.var/cache/ssh
ME=$(logname)@$(hostname)
### For remote operation ###
[ -d $SSHVAR/accept ] || mkdir -p $SSHVAR/accept
[ -d $SSHVAR/impose ] || mkdir -p $SSHVAR/impose
## For manipulating authorized_keys (can be reduced -> _overwrite)
# Set permission [oct] [files..]
_setp(){
    local oct=$1 pm file;shift
    for file; do
        [ -e $file ] || continue
        if [ $(stat -c%a $file) != "$oct" ]; then
            chmod $oct $file
            _warn "Permission for $file is changed to $oct"
        fi
    done
}
#link ssh-auth-mark
_ssh-auth-mark-old(){ # Mark '#' for own old pubkey [authorized_keys] (You can manualy set)
    #   maching own id_rsa.pub and the line, otherwise move older one to invalid_keys
    local ath=${1:-$LATH}
    local pub=$PUB
    [ -f $ath -a -f $pub ] || _abort "No ssh files"
    local rsa mykey me key host
    read rsa mykey me < $pub
    me=${me:-$ME}
    while read rsa key host; do
        if [[ ! "$rsa" =~ "#" ]] && [[ "$host" =~ "$me" ]] && [ "$mykey" != "$key" ] ; then
            echo "#$rsa $key $host"
            _warn "Old key is marked for $host"
            echo "$rsa $mykey $me"
        else
            echo "$rsa $key${host:+ $host}"
        fi
    done < $ath | sort -u | _overwrite $ath
}
#link ssh-auth-to-invalid
_ssh-auth-to-invalid(){ # Register marked line in [authorized_keys] to [invalid_keys]
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
    sort -u $tinv | _overwrite $inv 
    grep -v "^#" $ath | _overwrite $ath && _msg "authorized_keys was updated (rm marked line)"
}
#link ssh-auth-by-invalid
_ssh-auth-by-invalid(){ # Remove keys from [authorized_keys] by [invalid_keys]
    local ath=${1:-$LATH}
    local inv=${2:-$LINV}
    #  exculde invalid keys
    while read line;do
        if md="$(grep $(md5sum <<< $line | cut -c-32) $inv)"; then
            _warn "Removed Invalid Key for ${line##* } ($md)"
        else
            echo "$line"
        fi
    done < $ath | _overwrite $ath && _msg "authorized_keys was updated (rm by inv)"
}
#link ssh-auth-rm-dup
_ssh-auth-rm-dup(){ # Remove duplicated keys [authorized_keys]
    local ath=${1:-$LATH} list dup rsa key host i
    #  remove duplicated keys (compare key without host)
    while read rsa key host;do
        if [ "$pkey" = "$key" ]; then # Duplicated line
            dup=1
        elif [ "$pkey" ] ; then # Normal line
            list=$( _uniq $list | _list_csv )
            echo "ssh-rsa $pkey${list:+ $list}"
            [ "$dup" ] && _warn "Put Together Duplicated Key ($list)"
            unset list dup
        fi
        list="$list ${host//,/ }"
        pkey=$key
    done < <(sort -u $ath;echo) | _overwrite $ath
}
#link ssh-auth-trim
_ssh-auth-trim(){ # Trim authrized_keys and update invalid_keys
    _ssh-auth-mark-old $1
    _ssh-auth-to-invalid $*
    _ssh-auth-by-invalid $*
    _ssh-auth-rm-dup $1
}
#link ssh-auth-mates
_ssh-auth-mates(){ # List the mate accounts except myself in authorized_keys
    grep -v '^#' $LATH | grep -v $(cut -d' ' -f2 $PUB) | cut -d' ' -f3 | tr , $'\n' | grep @ 
}
#link ssh-file-perm
_ssh-file-perm(){ # Set ssh related file permission
    _setp 755 ~
    [ -d ~/.ssh ] || exit
    _msg "Correcting permission for ssh files"
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

# Set rhost,sshopt,port
_ssh-opt(){
    local site host user
    if [[ "$1" =~ @ ]] ; then
        IFS=':@';set - $1;unset IFS
        user=$1;host=$2;port=$3
    elif [ "$1" ] ; then
        user="$LOGNAME"
        IFS=':';set - $1;unset IFS
        host=$1;port=$2
    else
        _warn "No [site]"
        return 1
    fi
    [[ "$host" =~ (`hostname`|localhost) ]] && [ "$user" = $LOGNAME ] && { _warn "Self push"; return 1; }
    sshopt="-o StrictHostKeyChecking=no ${port:+-P $port}"
    rhost="$user@$host"
}
#link ssh-fetch
_ssh-fetch(){ # Fetch remote auth key [user@host:port]
    _ssh-opt $1 || return 1
    _warn "Host $rhost${port:+:$port}"
    # Get files from remote
    cd $SSHVAR
    scp $sshopt $rhost:.ssh/$ATH .
    scp $sshopt $rhost:.ssh/$INV .
    [ -s $ATH ] && mv $ATH $ATH.$rhost
    [ -s $INV ] && mv $INV $INV.$rhost
}
#link ssh-push
_ssh-push(){ # Push auth key to remote [user@host:port]
    _ssh-opt $1 || return 1
    local s1 s2 i
    [ -s $ATH ] && s1=$ATH
    if [ -s $ATH.$rhost ] ; then
        cmp -s $ATH $ATH.$rhost && s1=
        mv $ATH.$rhost old.$ATH.$rhost
    fi
    [ -s $INV ] && s2=$INV
    if [ -s $INV.$rhost ] ; then
        cmp -s $INV $INV.$rhost && s2=
        mv $INV.$rhost  old.$INV.$rhost
    fi
    if [ "$s1$s2" ] ; then
        scp -pq $sshopt $s1 $s2 $rhost:.ssh/ &&\
        for i in $s1 $s2;do
            _msg "$i($(stat -c%s $i)) is updated at $C2$rhost"
        done
    else
        _msg "Files are identical with $C2$rhost"
    fi
}
# Convert keys for accept (merge files)
_ssh-accept(){
    # Merge with local file
    cd $SSHVAR/accept/
    rm -f $ATH* $INV*
    mv ../*.* . >/dev/null 2>&1
    grep -h . $LATH $ATH.* >> $ATH
    grep -h . $LINV $INV.* >> $INV
    _ssh-auth-trim $ATH $INV
    _overwrite $LINV < $INV
    _overwrite $LATH < $ATH
}
# Convert keys for impose (remove site name)
_ssh-impose(){
    # Merge with local file
    cd $SSHVAR/impose/
    rm -f $ATH* $INV*
    mv ../*.$rhost . >/dev/null 2>&1
    # Conceal group members
    cut -d' ' -f1-2 $LATH > $ATH
    set - $(cut -d' ' -f3 $LATH|sort -u)
    IFS='|';local exp="($*)";unset IFS
    egrep -hv "$exp" $ATH.$rhost >> $ATH
    _ssh-auth-trim $ATH $INV.$rhost
}
#link ssh-validate
_ssh-validate(){ # Check remote availability [site]
    [ "$1" ] || { _warn "No [site]"; return 1; }
    local i 
    for i; do
        # execute dummy command ':'
        if ssh -q\
            -o "BatchMode=yes"\
            -o "ConnectTimeout=1"\
            -o "StrictHostKeyChecking=no"\
            $i :
        then
            echo -n '*' 1>&2
            echo $i
        else
            echo -n '.' 1>&2
        fi
    done
    echo  1>&2
}
_chkfunc $*
