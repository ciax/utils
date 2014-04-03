#!/bin/bash
# Required commands: cp,cut,grep,sort,md5sum
# Required scripts: func.app, edit-write, ssh-perm
# Description: mark '#' if the line with own name is found in authorized_keys,
#   maching own id_rsa.pub and the line, otherwise move older one to invalid_keys
. func.app
ath=~/.ssh/authorized_keys
pub=~/.ssh/id_rsa.pub
[ -f $ath -a -f $pub ] || _abort "No ssh files"
read rsa mykey me < $pub
_temp tath
while read line; do
    set - $line
    [ "$3" = "$me" ] && echo -n '#'
    echo "$line"
done < <(grep -v $mykey $ath) > $tath
sort -u $pub $tath | edit-write $ath && echo "Invalid keys are marked"
