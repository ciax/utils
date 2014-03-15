#!/bin/bash
# Required scripts: rc.app, edit-write, ssh-perm
# Required packages: coreutils(cp,cut,grep,sort,md5sum)
# Description: mark '#' if the line with own name is found in authorized_keys,
#   maching own id_rsa.pub and the line, otherwise move older one to invalid_keys
. rc.app
ath=~/.ssh/authorized_keys
pub=~/.ssh/id_rsa.pub
[ -f $ath -a -f $pub ] || { echo "No ssh files"; exit 1; }
read rsa mykey me < $pub
_temp tath
while read line; do
    set - $line
    [ "$3" = "$me" ] && echo -n '#'
    echo "$line"
done < <(grep -v $mykey $ath) > $tath
sort -u $pub $tath | edit-write $ath && echo "Invalid keys are marked"
