#!/bin/bash
# Required scripts: func.temp edit-write
# Description: mark '#' if the line with own name is found in authorized_keys,
#   maching own id_rsa.pub and the line, otherwise move older one to invalid_keys
#link ssh-mark
#link ssh-trim
#link ssh-mates
#link ssh-perm
. func.temp
ATH=.ssh/authorized_keys
INV=.ssh/invalid_keys
SEC=.ssh/id_rsa
PUB=.ssh/id_rsa.pub
_ssh-mark(){ # Mark '#' for own old pubkey [authorized_keys]
    ath=${1:-~/$ATH}
    pub=~/$PUB
    [ -f $ath -a -f $pub ] || _abort "No ssh files"
    read rsa mykey me < $pub
    _temp tath
    while read line; do
	set - $line
	[ "$3" = "$me" ] && echo -n '#'
	echo "$line"
    done < <(grep -v $mykey $ath) > $tath
    sort -u $pub $tath | edit-write $ath && _warn "Invalid keys are marked"
}
# Required scripts: edit-cutout line-dup edit-write
_ssh-trim(){ # Remove dup key [authorized_keys] [invalid_keys]
    ath=${1:-~/$ATH}
    inv=${2:-~/$INV}
    # Split file into invalid_keys by #headed line
    _temp tath tinv tdup
    cp $ath $tath
    ## For invalid_keys (increase only -> merge)
    while read line;do
	if [ ${#line} -gt 32 ]; then 
            md5sum <<< $line | cut -c-32
	else
            echo $line
	fi
    done < <(edit-cutout "^#" $tath;cat $inv) |sort -u > $tinv
    _overwrite $tinv $inv
    ## For authorized_keys (can be reduced -> _overwrite)
    #  exclude duplicated keys
    sort -u $tath> $tinv
    cut -d' ' -f1-2 $tinv|line-dup > $tdup
    #  exculde invalid keys
    while read line;do
	grep -q "$line" $tdup && continue
	grep -q $(md5sum <<< $line | cut -c-32) $inv && continue
	echo "$line"
    done < $tinv > $tath
    edit-write $ath $tath && _warn "authorized_key was updated"
}
_ssh-mates(){ # List the mate accounts in authorized_keys
    read rs mykey me < ~/$PUB
    cut -d' ' -f3 ~/$ATH|grep @|grep -v $me
}
_ssh-perm(){ # Set ssh related file permission
    cd;chmod 755 .
    [ -d ~/.ssh ] && cd ~/.ssh || exit
    chmod 700 .
    for i in $ATH $INV $SEC $PUB;do [ -f "$i" ] && chmod 600 $i; done
}
_chkfunc $*
