#!/bin/bash
# Required script: set.tempfile, file-move.sh, ssh-perm.sh
# Required command: cp,cut,grep,sort
# Remove dup key from authorized_keys
auth=~/.ssh/authorized_keys
inv=~/.ssh/invalid_keys
pub=~/.ssh/id_rsa.pub
me=`cut -d' ' -f3 $pub`
. set.tempfile tath1 tath2 tinv1 tinv2
#
# Split file into #headed line(invalid keys) and others
#
egrep -v '[#*]' $auth|grep '.' > $tath1
egrep '^#' $auth > $tinv1
if [ -f "$inv" ] ; then
    while read key; do
        grep -v "$key" $tath1 > $tath2
        cp $tath2 $tath1
        echo "$key" >> $tinv2
    done < <(grep '.' $inv $tinv|cut -d' ' -f2|sort -u)
    file-move $tinv2 $inv
fi
file-move $tath1 $auth
ssh-perm