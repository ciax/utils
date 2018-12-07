#!/bin/bash
# Description: overwrite the file in a hash directive (#file) by stdin
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
_overwrite $dstfile $srcfile

