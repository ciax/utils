#!/bin/bash
# Required commands: mawk
# Required scripts: func.getpar
# Description: reorder columns of the csv file
#alias swcol
. func.getpar
_usage "[order(1,2,3..)] [file] (-w)"
order="\$${1//,/,\$}"
file=$2
_temp tmp1
<$file awk -F "\t" "BEGIN{ OFS=FS; }{ print $order; }" > $tmp1
if [ "$3" = "-w" ] ; then
    _overwrite $file < $tmp1
else
    cat $tmp1
fi
