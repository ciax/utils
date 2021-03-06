#!/bin/bash
# Required scripts: func.getpar
# Description: Append STDIN to an original file in a hash directive (#file)
#              No overwrite if the line exists in original file.
# Usage: text-append < file
# Example: cfg-hosts | text-append (STDIN indludes output file name "#file /etc/hosts")
#alias append
. func.getpar
_import func.sudo
_usage "<input>"
_temp infile outfile
rem=$( tee $infile | grep "^#file" )
dstfile=${rem#* }
[ "$dstfile" ] || _abort "No output file name"
cat $dstfile > $outfile
while read line; do
    [ "$line" ] || continue
    egrep -q "$line" $dstfile && continue
    echo "$line" >> $outfile
done < <(egrep -v "^#" $infile)
_overwrite $dstfile $outfile
