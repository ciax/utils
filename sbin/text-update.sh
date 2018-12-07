#!/bin/bash
# Description: overwrite the file in a hash directive (#file) by stdin
. func.sudo
_usage "<input>"
_temp srcfile
while read line; do
    if [[ $line =~ ^#file ]] ; then
        dstfile=${line#* }
    else
        echo "$line" >> $srcfile
    fi
done
_overwrite_s $dstfile $srcfile

