#!/bin/bash
# Required script: func.temp, edit-merge, ssh-perm
# Required packages: coreutils(cp,cut,grep,sort,md5sum)
# Remove dup key from authorized_keys
# Usage: ssh-trim (authorized_keys) (invalid_keys)
getmd5(){ md5sum <<< $2 | cut -c-32; }
ath=${1:-~/.ssh/authorized_keys}
inv=${2:-~/.ssh/invalid_keys}
pub=~/.ssh/id_rsa.pub
#
# Split file into invalid_keys by #headed line, old key and others
#
. func.temp tath tath2
read rsa mykey me < $pub
#  If the line with own name is found in authorized_keys,
#  maching own id_rsa.pub and the line, otherwise move older one to invalid_keys
# For invalid_keys (increase only -> merge)
grep -v $mykey $ath > $tath
while read line;do
    getmd5 $line
done < <(edit-cutout "^#|$me" $tath) | edit-merge $inv
# For authorized_keys (can be reduced -> overwrite)
while read line;do
    grep -q $(getmd5 $line) $inv || echo "$line"
done < $tath > $tath2
sort -u $tath2 $pub > $tath
overwrite $tath $ath && echo "authorized_key was updated"
