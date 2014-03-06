#!/bin/bash
# Required script: func.temp, ssh-perm.sh
# Required packages: coreutils(cp,cut,grep,sort,md5sum)
# Remove dup key from authorized_keys
ath=~/.ssh/authorized_keys
inv=~/.ssh/invalid_keys
pub=~/.ssh/id_rsa.pub
#
# Split file into invalid_keys by #headed line, old key and others
#
. func.temp tath tinv
read rsa mykey me < $pub
# If the line with own name is found in authorized_keys,
# maching own id_rsa.pub and the line, otherwise move older one to invalid_keys
for i in $(egrep -v $mykey $ath|egrep '^#|$me' $ath|cut -d' ' -f2) $(<$inv);do
    if [ ${#i} -gt 32 ] ; then
        md5sum <<< $i
    else
        echo $i
    fi
done|cut -d' ' -f1|sort -u > $tinv
overwrite $tinv $inv
while read line; do
    set - $line
    grep -q $(echo $2|md5sum|cut -d' ' -f1) $inv || echo "$line"
done < $ath > $tath
edit-merge $pub $tath
overwrite $tath $ath
