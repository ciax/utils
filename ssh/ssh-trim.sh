#!/bin/bash
# Required script: func.temp, edit-merge, ssh-perm
# Required packages: coreutils(cp,cut,grep,sort,md5sum)
# Remove dup key from authorized_keys
# Usage: ssh-trim (authorized_keys) (invalid_keys)
getmd5(){ md5sum <<< $2 | cut -c-32; }
ath=${1:-~/.ssh/authorized_keys}
inv=${2:-~/.ssh/invalid_keys}
#
# Split file into invalid_keys by #headed line
#
. func.temp tath tinv tdup
## For invalid_keys (increase only -> merge)
while read line;do
    if [ ${#line} -gt 32 ]; then 
	getmd5 $line
    else
	echo $line
    fi
done < <(edit-cutout "^#" $ath;cat $inv) |sort -u > $tinv
overwrite $tinv $inv
## For authorized_keys (can be reduced -> overwrite)
#  exclude duplicated keys
cut -d' ' -f1-2 $ath|line-dup > $tdup
#  exculde invalid keys
while read line;do
    grep -q "$line" $tdup && continue
    grep -q $(getmd5 $line) $inv && continue
    echo "$line"
done < $ath |sort -u > $tath
overwrite $tath $ath && echo "authorized_key was updated"
