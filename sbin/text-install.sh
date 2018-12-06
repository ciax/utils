#!/bin/bash
# Description: overwrite the file in a hash directive (#file) by stdin
source func.getpar
source func.sudo
if [ ! -t 0 ] ; then
    _temp srcfile
    while read line; do
        if [[ $line =~ ^#file ]] ; then
            dstfile=${line#* }
        else
            echo "$line" >> $srcfile
        fi
    done
elif [ ! "$srcfile" ] ; then
    _usage " < input file"
fi
_overwrite_s $dstfile $srcfile

