#!/bin/bash
# Required packages: coreutils(cp,cut,grep,sort,md5sum)
# Required scripts: rc.app, edit-cutout, line-dup, edit-write
# Description: remove dup key from authorized_keys
# Usage: ssh-trim (authorized_keys) (invalid_keys)
. rc.app
getmd5(){ md5sum <<< $2 | cut -c-32; }
ath=${1:-~/.ssh/authorized_keys}
inv=${2:-~/.ssh/invalid_keys}
#
# Split file into invalid_keys by #headed line
#
_temp tath tinv tdup
cp $ath $tath
## For invalid_keys (increase only -> merge)
while read line;do
    if [ ${#line} -gt 32 ]; then 
	getmd5 $line
    else
	echo $line
    fi
done < <(edit-cutout "^#" $tath;cat $inv) |sort -u > $tinv
_overwrite $tinv $inv
## For authorized_keys (can be reduced -> _overwrite)
#  exclude duplicated keys
sort -u $tath> $tinv
cut -d' ' -f1-2 $tinv|line-dup > $tdup
#  exculde invalid keys
while read line;do
    grep -q "$line" $tdup && continue
    grep -q $(getmd5 $line) $inv && continue
    echo "$line"
done < $tinv > $tath
edit-write $ath $tath && echo "authorized_key was updated"
