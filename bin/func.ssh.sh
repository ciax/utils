#!/bin/bash
# Required scripts: func.file
# Description: Mark '#' at the head of a line in authorized_keys to reserve for registration to the invalid_keys.
type _setp >/dev/null 2>&1 && return
. func.list
ATH=authorized_keys
INV=invalid_keys
PRV=~/.ssh/id_rsa
PUB=~/.ssh/id_rsa.pub
CFG=~/.ssh/config
LATH=~/.ssh/$ATH
LINV=~/.ssh/$INV
ETC=~/etc/ssh
SSHVAR=~/.var/cache/ssh
ME=$USER@$(hostname)
### For remote operation ###
mkdir -p $SSHVAR/accept
mkdir -p $SSHVAR/impose
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
_ssh_auth_mark_old(){ # Mark '#' for own old pubkey [authorized_keys] (You can manualy set)
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
#link ssh_auth_to_invalid
_ssh_auth_to_invalid(){ # Register marked line in [authorized_keys] to [invalid_keys]
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
    grep -v "^#" $ath | _overwrite $ath && _comp "authorized_keys was updated (rm marked line)"
}
#link ssh_auth_by_invalid
_ssh_auth_by_invalid(){ # Remove keys from [authorized_keys] by [invalid_keys]
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
#link ssh_auth_rm_dup
_ssh_auth_rm_dup(){ # Remove duplicated keys [authorized_keys]
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
#link ssh_auth_trim
_ssh_auth_trim(){ # Trim authrized_keys and update invalid_keys
    _ssh_auth_mark_old $1
    _ssh_auth_to_invalid $*
    _ssh_auth_by_invalid $*
    _ssh_auth_rm_dup $1
}
#link ssh_auth_mates
_ssh_auth_mates(){ # List the mate accounts except myself in authorized_keys
    grep -v '^#' $LATH | grep -v $(cut -d' ' -f2 $PUB) | cut -d' ' -f3 | tr , $'\n' | grep @ 
}
#link ssh_file_perm
_ssh_file_perm(){ # Set ssh related file permission
    _setp 755 ~
    [ -d ~/.ssh ] || exit
    _msg "Correcting permission for ssh files"
    cd ~/.ssh
    _setp 700 .
    _setp 600 id_rsa gpgpass
    _setp 644 !(id_rsa|gpgpass)
}
_ssh_setup(){ # Setup ssh
    type ssh > /dev/null || _abort "No ssh installed"
    [ -e $PRV ] || ssh-keygen
    [ -e $PUB ] || ssh-keygen -y -f $PRV > $PUB
    [ -e $LINV ] || touch $LINV
    [ -e $LATH ] || cp $PUB $LATH
    [ -e $ETC ] && cp $PUB $ETC/$USER.$HOSTNAME.pub
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
#link ssh_fetch
_ssh_fetch(){ # Fetch remote auth key [user@host:port]
    _ssh-opt $1 || return 1
    _warn "Host $rhost${port:+:$port}"
    cd $SSHVAR
    # Push pubkey to prevent the multiple password input
    ssh $sshopt $rhost "cat >> ~/.ssh/$ATH" < $PUB
    # Get files from remote
    scp $sshopt $rhost:.ssh/$ATH .
    scp $sshopt $rhost:.ssh/$INV .
    [ -s $ATH ] && mv $ATH $ATH.$rhost
    [ -s $INV ] && mv $INV $INV.$rhost
    # Get github credentials
    cd
    gcre=".git-credentials"
    _temp tcre
    cp $gcre $tcre
    ssh $sshopt $rhost "cat $gcre" >> $tcre 
    sort -u $tcre | _overwrite $gcre
}
#link ssh_push
_ssh_push(){ # Push auth key to remote [user@host:port]
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
    _ssh_auth_trim $ATH $INV
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
    _ssh_auth_trim $ATH $INV.$rhost
}
#link ssh_validate
_ssh_validate(){ # Check remote availability [site]
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
            _progress '*'
            echo $i
        else
            _progress
        fi
    done
    echo  1>&2
}
_chkfunc $*
