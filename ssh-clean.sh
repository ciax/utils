#!/bin/bash
# Required command: cmp,cp,ssh,cut,grep,cut,sort,cp
# Required script: set.tempfile, ssh-setup.sh
# Remove dup key from authorized_keys
# No change, no rewrite
update(){
    cmp -s $1 $2 && return
    cp $1 $2
    chmod 600 $2
    echo "$2 is cleaned"
}
ssh-setup
auth=~/.ssh/authorized_keys
inv=~/.ssh/invalid_keys
pub=~/.ssh/id_rsa.pub
me=`cut -d' ' -f3 $pub`
. set.tempfile tath1 tath2 tinv1 tinv2
# Remove #headed line
egrep -v '[#*]' $auth|grep '.' > $tath1
egrep '^#' $auth > $tinv1
if [ -f "$inv" ] ; then
    grep '.' $inv $tinv|cut -d' ' -f2|sort -u|while read key; do
    grep -v "$key" $tath1 > $tath2
    cp $tath2 $tath1
    echo "$key" >> $tinv2
    done
    update $tinv2 $inv
fi
update $tath1 $auth
