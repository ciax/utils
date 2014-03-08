#!/bin/bash
# Description: reorder columns of the file
# Required scripts: func.usage, func.temp
# Required packages: coreutils(cat),mawk
. func.usage "[order(1,2,3..)] [file] (-w)" $2
order="\$${1//,/,\$}"
file=$2
. func.temp tmp1
<$file awk -F "\t" "BEGIN{ OFS=FS; }{ print $order; }" > $tmp1
if [ "$3" = "-w" ] ; then
    overwrite $tmp1 $file
else
    cat $tmp1
fi
