#!/bin/bash
# Required scripts: func.temp
# Description: mark '#' if the line with own name is found in authorized_keys,
#   maching own id_rsa.pub and the line, otherwise move older one to invalid_keys
#link ssh-mark
#link ssh-trim
#link ssh-mates
#link ssh-perm
#link ssh-pull
. func.temp
. func.attr
. func.text
ATH=.ssh/authorized_keys
INV=.ssh/invalid_keys
SEC=.ssh/id_rsa
PUB=.ssh/id_rsa.pub
CFG=.ssh/config
_ssh-mark(){ # Mark '#' for own old pubkey [authorized_keys]
    local ath=${1:-~/$ATH}
    local pub=~/$PUB
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
_ssh-trim(){ # Remove dup key [authorized_keys] [invalid_keys]
    local ath=${1:-~/$ATH}
    local inv=${2:-~/$INV}
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
        grep -q "$line" $tdup && continue
        grep -q $(md5sum <<< $line | cut -c-32) $inv && continue
        echo "$line"
    done < $tath | _overwrite $ath && _warn "authorized_key was updated"
}
_ssh-mates(){ # List the mate accounts in authorized_keys
    local dmy me
    read dmy dmy me < ~/$PUB
    cut -d' ' -f3 ~/$ATH|grep @|grep -v $me
}
_ssh-perm(){ # Set ssh related file permission
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
    [ -e ~/$SEC ] || ssh-keygen
    [ -e ~/$PUB ] || ssh-keygen -y -f ~/$SEC > ~/$PUB
    [ -e ~/$INV ] || touch ~/$INV
    [ -e ~/$ATH ] || cp ~/$PUB ~/$ATH
    grep -q "$(< ~/$PUB)" ~/$ATH || cat ~/$PUB >> ~/$ATH
}
_ssh-pull(){ # Pull and merge auth key (user@host port)
    local rhost=$1 port=${2:-22}
    [[ "$rhost" =~ (`hostname`|localhost) ]] && _abort "Self push"
    local sshopt="-o StrictHostKeyChecking=no -P $port"
    local rath rinv tath tinv
    _temp rath rinv tath tinv
    echo "Host $rhost:$port"
    # Get files from remote
    scp -pq $sshopt $rhost:$ATH $rath
    scp -pq $sshopt $rhost:$INV $rinv
    # Join with local file
    cat $rath ~/$ATH > $tath
    cat $rinv ~/$INV > $tinv
    # Trimming
    _ssh-mark $tath
    _ssh-trim $tath $tinv >/dev/null
    # Renew local files
    _overwrite ~/$INV < $tinv
    # Show merged authrized_keys
    cat $tath
}

_chkfunc $*
