#!/bin/bash
# Required packages: coreutils(cat),mawk
# Required scripts: src.app
# Description: reorder columns of the file
. src.app
_usage "[order(1,2,3..)]" "[file] (-w)"
order="\$${1//,/,\$}"
file=$2
_temp tmp1
<$file awk -F "\t" "BEGIN{ OFS=FS; }{ print $order; }" > $tmp1
if [ "$3" = "-w" ] ; then
    _overwrite $tmp1 $file
else
    cat $tmp1
fi
