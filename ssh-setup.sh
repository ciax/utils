#!/bin/bash
# Required script: set.tempfile.sh, ssh-trim.sh
# Required command: coreutils(grep,cut,cat,sort),diffutils(cmp),ssh,ssh-keygen
# Usage: ${0##*/} (-r:remove keys)
ath=~/.ssh/authorized_keys
inv=~/.ssh/invalid_keys
sec=~/.ssh/id_rsa
pub=~/.ssh/id_rsa.pub
[ "$1" = -r ] && rm $sec $pub
type ssh > /dev/null || apt-get install ssh
[ -e $sec -a -e $pub ] || ssh-keygen
[ -e $ath ] || touch $ath
[ -e $inv ] || touch $inv
#
# Add my id_rsa.pub to authorized_keys (if not exist)
#
# If the line with own name is found in authorized_keys,
# maching own id_rsa.pub and the line, otherwise move older one to invalid_keys
me=`cut -d' ' -f3 $pub`
key=`cut -d' ' -f2 $pub`
# Make temp
. set.tempfile tinv tath
{ egrep "$me" $ath|grep -v "$key"|cut -d' ' -f2;cat $inv; }|sort -u > $tinv
{ grep -v "$me" $ath;cat $pub; }|sort -u > $tath
# No change, no rewrite
overwrite $tath $ath -w && echo "added new key to authorized_keys"
overwrite $tinv $inv -w && echo "added new key to invalid_keys"
ssh-trim