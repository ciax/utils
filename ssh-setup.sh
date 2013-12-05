#!/bin/bash
# Required script: set.tempfile.sh
# Required command: ssh,ssh-keygen,grep,cut,cat,sort,cmp
# Usage: ${0##*/} (-r:remove keys)
ath=~/.ssh/authorized_keys
inv=~/.ssh/invalid_keys
sec=~/.ssh/id_rsa
pub=~/.ssh/id_rsa.pub
[ "$1" = -r ] && rm $sec $pub
type ssh > /dev/null || apt-get install ssh
[ -e $sec -a -e $pub ] || ssh-keygen
# Permission Setting
chmod 700 ~/.ssh
chmod 600 $sec
[ -e $ath ] || touch $ath
[ -e $inv ] || touch $inv
chmod 600 $ath
chmod 600 $inv
# Make temp
. set.tempfile tinv tath
# If the line with own name is found in authorized_keys,
# maching own id_rsa.pub and the line, otherwise move older one to invalid_keys
me=`cut -d' ' -f3 $pub`
key=`cut -d' ' -f2 $pub`
{ egrep "$me" $ath|grep -v "$key"|cut -d' ' -f2;cat $inv; }|sort -u > $tinv
{ grep -v "$me" $ath;cat $pub; }|sort -u > $tath
# No change, no rewrite
if ! cmp -s $ath $tath ; then
    cp $tath $ath
    chmod 600 $ath
    echo "added new key to authorized_keys"
fi
if ! cmp -s $inv $tinv ; then
    cp $tinv $inv
    chmod 600 $inv
    echo "added new key to invalid_keys"
fi
