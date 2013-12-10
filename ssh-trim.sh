#!/bin/bash
# Required script: set.tempfile, file-move.sh, ssh-perm.sh
# Required command: coreutils(cp,cut,grep,sort)
# Remove dup key from authorized_keys
ath=~/.ssh/authorized_keys
inv=~/.ssh/invalid_keys
pub=~/.ssh/id_rsa.pub
. set.tempfile tath1 tath2 tinv1 tinv2
#
# Split file into #headed line(invalid keys) and others
#
egrep -v '[#*]' $ath|grep '.' > $tath1
egrep '^#' $ath > $tinv1
if [ -f "$inv" ] ; then
    while read key; do
        grep -v "$key" $tath1 > $tath2
        cp $tath2 $tath1
        echo "$key" >> $tinv2
    done < <(grep '.' $inv $tinv|cut -d' ' -f2|sort -u)
    file-move $tinv2 $inv
fi
file-move $tath1 $ath
ssh-perm
