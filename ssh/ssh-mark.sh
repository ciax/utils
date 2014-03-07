#!/bin/bash
# Required script: func.temp, edit-merge, ssh-perm
# Required packages: coreutils(cp,cut,grep,sort,md5sum)
#  Mark '#' if the line with own name is found in authorized_keys,
#  maching own id_rsa.pub and the line, otherwise move older one to invalid_keys
ath=~/.ssh/authorized_keys
pub=~/.ssh/id_rsa.pub
[ -f $ath -a -f $pub ] || { echo "No ssh files"; exit 1; }
read rsa mykey me < $pub
. func.temp tath tath2
while read line; do
    set - $line
    [ "$3" = "$me" ] && echo -n '#'
    echo "$line"
done < <(grep -v $mykey $ath) > $tath
sort -u $pub $tath > $tath2
overwrite $tath2 $ath && echo "Invalid keys are marked"
