#!/bin/bash
# Description: overwrite the file in a hash directive (#file) by stdin
source func.getpar
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
[ "$dstfile" ] || _abort "No output file specified"
if [ ! -e $dstfile ] ; then
    dir=$(dirname $dstfile)
    user=$(_fuser $dir)
    sudo -u $user mkdir -p "$dir"
    sudo mv $srcfile $dstfile
    sudo chown $user $dstfile
    _warn "$dstfile is created"
elif sudo cmp -s $srcfile $dstfile ; then
    rm -f $srcfile
    _warn "No changes on $dstfile"
    exit 1
else
    user=$(_fuser $dstfile)
    _verbose "file diff" && diff $dstfile $srcfile 1>&2
    chmod --reference=$dstfile $srcfile
    sudo mv -b $dstfile ~/.trash/ || _warn "Failed backup $dstfile"
    sudo mv $srcfile $dstfile
    sudo chown $user $dstfile
    _warn "$dstfile is modified"
fi
