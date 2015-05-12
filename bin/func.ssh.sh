#!/bin/bash
# Required scripts: func.temp
# Description: mark '#' if the line with own name is found in authorized_keys,
#   maching own id_rsa.pub and the line, otherwise move older one to invalid_keys
#link auth-mark
#link auth-trim
#link auth-mates
#link auth-perm
#link ssh-fetch
. func.temp
. func.attr
. func.text
ATH=.ssh/authorized_keys
INV=.ssh/invalid_keys
SEC=~/.ssh/id_rsa
PUB=~/.ssh/id_rsa.pub
CFG=~/.ssh/config
LATH=~/$ATH
LINV=~/$INV
MATH=$LATH.merge
MINV=$LINV.merge
AATH=$LATH.anony
_auth-mark(){ # Mark '#' for own old pubkey [authorized_keys]
    local ath=${1:-$LATH}
    local pub=$PUB
    [ -f $ath -a -f $pub ] || _abort "No ssh files"
    local rsa mykey me tath line
    read rsa mykey me < $pub
    _temp tath
    grep -v $mykey $ath|\
        while read line; do
            set - $line
            [ "$3" = "$me" ] && echo -n '#'
           echo "$line"
        done > $tath
    sort -u $pub $tath | _overwrite $ath && _warn "Invalid keys are marked"
}
# Required scripts: line-dup
_auth-trim(){ # Remove dup key [authorized_keys] [invalid_keys]
    local ath=${1:-$LATH}
    local inv=${2:-$LINV}
    # Split file into invalid_keys by #headed line
    local tath tinv tdup
    _temp tath tinv tdup
    cp $inv $tinv
    ## For invalid_keys (increase only -> merge)
    grep "^#" $ath|\
        while read line;do
            md5sum <<< $line | cut -c-32
        done >> $tinv
    sort -u $tinv | _overwrite $inv
    ## For authorized_keys (can be reduced -> _overwrite)
    #  exclude duplicated keys (the key should be treated by the owner)
    grep -v "^#" $ath | tee $tath | cut -d' ' -f1-2 | _text-dup > $tdup
    #  exculde invalid keys
    local line
    while read line;do
        if grep -q "$line" $tdup; then
            _warn "Remove Duplicated Key ${line##* }"
        elif grep $(md5sum <<< $line | cut -c-32) $inv > $tinv; then
            _warn "Remove Invalid Key for ${line##* } ($(< $tinv))"
        else
            echo "$line"
        fi
    done < $tath | _overwrite $ath && _warn "authorized_key was updated"
}
_auth-mates(){ # List the mate accounts in authorized_keys
    local dmy me
    read dmy dmy me < $PUB
    cut -d' ' -f3 $LATH|grep @|grep -v $me
}
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
_sshopt(){
    IFS=:;set - $1;rhost=$1;port=$2;unset IFS
    [[ "$rhost" =~ (`hostname`|localhost) ]] && { _warn "Self push"; return 1; }
    sshopt="-o StrictHostKeyChecking=no ${port:+-P $port}"
}
_ssh-fetch(){ # Fetch and merge auth key (user@host:port)
    _sshopt $1 || return 1
    local rath rinv
    _temp rath rinv
    echo "Host $rhost${port:+:$port}"
    # Get files from remote
    scp -pq $sshopt $rhost:$ATH $rath
    scp -pq $sshopt $rhost:$INV $rinv
    # Join with local file
    cat $rath $LATH > $MATH
    cat $rinv $LINV > $MINV
    cut -d' ' -f1-2 $LATH > $AATH
    cat $rath >> $AATH
    # Trimming
    _auth-mark $MATH
    _auth-mark $AATH
    _auth-trim $MATH $MINV >/dev/null
    _auth-trim $AATH $MINV >/dev/null
}
_ssh-admit(){
    _ssh-fetch $1 || return 1
    _overwrite < $LATH.merge $LATH
    _overwrite < $LINV.merge $LINV
}
_ssh-anonymous(){
    local anonymous
    _temp anonymous
    cut -d' ' -f1-2 < $LATH.merge > $anonymous
    _overwrite < $anonymous > $LATH.merge
}
_ssh-push-all(){
    scp -pq $sshopt $AATH $rhost:$ATH
    scp -pq $sshopt $LINV.merge $rhost:$INV
}
_ssh-share(){
    scp -pq $sshopt $LATH $rhost:$ATH
    scp -pq $sshopt $LINV $rhost:$INV
}
#link ssh-push-inv
_ssh-push-inv(){
    _sshopt $1 || return 1
    scp -pq $sshopt $LINV $rhost:$INV
}
_chkfunc $*
