#!/bin/bash
# Description: overwrite the file in a hash directive (#file) by stdin
#  *** Specify Absolute Directory. Never use '~/' for home. Use $HOME instead. ***
. func.getpar
_import func.sudo
_usage "<input>"
_temp srcfile
while read line; do
    if [[ $line =~ ^#file ]] ; then
        dstfile=${line#* }
    else
        echo "$line" >> $srcfile
    fi
done
[ "$dstfile" ] || _abort "No output file name"
_overwrite $dstfile $srcfile

