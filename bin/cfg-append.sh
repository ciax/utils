#!/bin/bash
# Required scripts: func.getpar
# Description: append stdin to config file which is included in stdin as a comment
#              and ignore existent line
# Usage: cfg-append < cfgfile
# Example: cfg-hosts | cfg-append
#alias append
. func.getpar
_usage "<newcfg>"
_temp infile outfile
rem=$( tee $infile | grep "^#/" )
file=${rem#*#}
[ "$file" ] || _abort "No cfg file name"
cat $file > $outfile
while read line; do
    [ "$line" ] || continue
    egrep -q "$line" $file && continue
    echo "$line" >> $outfile
done < <(egrep -v "^#" $infile)
if cmp -s $outfile $file ; then
    user=$(_fuser $file)
    sudo install -o $user $outfile $file
    _msg "Add to $file"
else
    _msg "No changes on $file"
fi
