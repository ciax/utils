#!/bin/bash
# Required scripts: func.temp edit-write
# Description: mark '#' if the line with own name is found in authorized_keys,
#   maching own id_rsa.pub and the line, otherwise move older one to invalid_keys
#link ssh-mark
#link ssh-trim
#link ssh-mates
#link ssh-perm
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
    sort -u $pub $tath | edit-write $ath && _warn "Invalid keys are marked"
}
# Required scripts: line-dup edit-write
_ssh-trim(){ # Remove dup key [authorized_keys] [invalid_keys]
    local ath=${1:-~/$ATH}
    local inv=${2:-~/$INV}
    # Split file into invalid_keys by #headed line
    local tath tinv tdup
    _temp tath tinv tdup
    cp $ath $tath
    ## For invalid_keys (increase only -> merge)
    _cutout "^#" $tath;cat $inv|\
        while read line;do
            if [ ${#line} -gt 32 ]; then 
                md5sum <<< $line | cut -c-32
            else
                echo $line
            fi
        done |sort -u > $tinv
    _overwrite $inv < $tinv
    ## For authorized_keys (can be reduced -> _overwrite)
    #  exclude duplicated keys
    sort -u $tath> $tinv
    cut -d' ' -f1-2 $tinv|_text-dup > $tdup
    #  exculde invalid keys
    local line
    while read line;do
        grep -q "$line" $tdup && continue
        grep -q $(md5sum <<< $line | cut -c-32) $inv && continue
        echo "$line"
    done < $tinv > $tath
    edit-write $ath $tath && _warn "authorized_key was updated"
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
_chkfunc $*
