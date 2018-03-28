#!/bin/bash
# Required scripts: func.getpar
# Description: Remove comment lines in original file and append new line which is listed in STDIN
#              No overwrite if the line exists in original file.
# Usage: text-concat < listfile
#alias cfgedit
. func.getpar
_usage "<input>"
_temp infile outfile
rem=$( tee $infile | grep "^#/" )
file=${rem#*#}
[ "$file" ] || _abort "No output file name"
while read line; do
    [ "$line" ] || continue
    set - $line
    if new=$(egrep "^$1" $infile); then
        echo "#$line" >> $outfile
    else
        echo "$line" >> $outfile
    fi
done < $file
grep -v "^#/" $infile >> $outfile
if cmp -s $outfile $file ; then
    user=$(_fuser $file)
    sudo install -o $user $outfile $file
    _msg "$file is modified"
else
    _msg "No changes on $file"
fi
