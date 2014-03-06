#!/bin/bash
# Required script: func.temp, ssh-perm.sh
# Required packages: coreutils(cp,cut,grep,sort,md5sum)
# Remove dup key from authorized_keys
getmd5(){ md5sum <<< $2 | cut -c32; }
ath=~/.ssh/authorized_keys
inv=~/.ssh/invalid_keys
pub=~/.ssh/id_rsa.pub
#
# Split file into invalid_keys by #headed line, old key and others
#
. func.temp tath tinv tath2
read rsa mykey me < $pub
#  If the line with own name is found in authorized_keys,
#  maching own id_rsa.pub and the line, otherwise move older one to invalid_keys
# For invalid_keys
grep -v $mykey $ath > $tath
while read line;do
    getmd5 $line
done < <(edit-cutout '^#|$me' $tath) > $tinv
edit-merge $tinv $inv
# For authorized_keys
while read line;do
    grep -q $(getmd5 $line) $inv || echo "$line"
done < $tath > $tath2
edit-merge $pub $tath2
overwrite $tath2 $ath
