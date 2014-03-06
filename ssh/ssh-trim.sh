#!/bin/bash
# Required script: func.temp, ssh-perm.sh
# Required packages: coreutils(cp,cut,grep,sort)
# Remove dup key from authorized_keys
ath=~/.ssh/authorized_keys
inv=~/.ssh/invalid_keys
pub=~/.ssh/id_rsa.pub
. func.temp tath1 tath2 tinv1 tinv2
#
# Split file into invalid_keys by #headed line and others
#
egrep -v '[#*]' $ath|grep '.' > $tath1
egrep '^#' $ath > $tinv1
if [ -f "$inv" ] ; then
    mykey=$(cut -d ' ' -f2 $pub)
    while read key; do
        grep -v "$key" $tath1 > $tath2
        cp $tath2 $tath1
        echo "$key" >> $tinv2
    done < <(grep -h '.' $inv $tinv|grep -v -e ':' -e "$mykey"|cut -d' ' -f2|sort -u)
    overwrite $tinv2 $inv
fi
overwrite $tath1 $ath
ssh-perm
