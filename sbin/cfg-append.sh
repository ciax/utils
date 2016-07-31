#!/bin/bash
# Required scripts: func.getpar
# Description: Append STDIN to an original file which is described as a comment in it.
#              No overwrite if the line exists in original file.
# Usage: cfg-append < file
# Example: cfg-hosts | cfg-append (STDIN indludes output file name "#file /etc/hosts")
#alias append
. func.getpar
_usage "<input>"
_temp infile outfile
rem=$( tee $infile | grep "^#file" )
orgfile=${rem#* }
[ "$orgfile" ] || _abort "No output file name"
cat $orgfile > $outfile
while read line; do
    [ "$line" ] || continue
    egrep -q "$line" $orgfile && continue
    echo "$line" >> $outfile
done < <(egrep -v "^#" $infile)
if cmp -s $outfile $orgfile ; then
    _msg "No changes on $orgfile"
else
    user=$(_fuser $orgfile)
    sudo install -o $user $outfile $orgfile
    _msg "Add to $orgfile"
fi
