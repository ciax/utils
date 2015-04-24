#!/bin/bash
# Required scripts: func.temp
# Description: append stdin to config file which is included in stdin as a comment
#              and ignore existent line
# Usage: cfg-append < cfgfile
# Example: cfg-hosts | cfg-append
. func.temp
_usage "<newcfg>"
_temp infile outfile
rem=$( tee $infile | grep "^#/" )
file=${rem#*#}
[ "$file" ] || _abort "No cfg file name"
user=$(_fuser $file)
cat $file > $outfile
while read line; do
    [ "$line" ] || continue
    egrep -q "$line" $file && continue
    echo "$line" >> $outfile
done < <(egrep -v "^#" $infile)
sudo install -o $user $outfile $file
