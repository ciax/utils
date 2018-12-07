#!/bin/bash
# Required scripts: func.getpar
# Description: Remove comment lines in original file and append new line which is included in STDIN like '#/dir/file'
#              No overwrite if the line exists in original file.
# Usage: text-concat < listfile
#alias cfgedit
. func.sudo
_usage "<input>"
_temp infile outfile
rem=$( tee $infile | grep "^#/" )
dstfile=${rem#*#}
[ "$dstfile" ] || _abort "No output file name"
while read line; do
    [ "$line" ] || continue
    set - $line
    if new=$(egrep "^$1" $infile); then
        echo "#$line" >> $outfile
    else
        echo "$line" >> $outfile
    fi
done < $dstfile
grep -v "^#/" $infile >> $outfile
_overwrite_s $dstfile $outfile
