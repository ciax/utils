#!/bin/bash
# Required scripts: func.getpar, edit-write, ssh-perm
# Description: mark '#' if the line with own name is found in authorized_keys,
#   maching own id_rsa.pub and the line, otherwise move older one to invalid_keys
. func.getpar
ath=${1:-~/.ssh/authorized_keys}
pub=~/.ssh/id_rsa.pub
[ -f $ath -a -f $pub ] || _abort "No ssh files"
read rsa mykey me < $pub
. func.temp
_temp tath
while read line; do
    set - $line
    [ "$3" = "$me" ] && echo -n '#'
    echo "$line"
done < <(grep -v $mykey $ath) > $tath
sort -u $pub $tath | edit-write $ath && echo "Invalid keys are marked"
