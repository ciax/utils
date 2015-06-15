#!/bin/bash
# Required scripts: func.getpar
# Description: Append STDIN to a file which is described as a comment in it.
#              No overwrite if the line exists.
# Usage: text-append < file
# Example: cfg-hosts | text-append (STDIN indludes output file name "#/etc/hosts")
#alias append
. func.getpar
_usage "<input>"
_temp infile outfile
rem=$( tee $infile | grep "^#/" )
file=${rem#*#}
[ "$file" ] || _abort "No output file name"
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
