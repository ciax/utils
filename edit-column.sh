#!/bin/bash
# Required script: func.usage, set.tempfile
# Required packages: coreutils(cat),mawk
# Reorder columns except key
. func.usage "[order(1,2,3..)] [file] (-w)" $2
order="\$${1//,/,\$}"
file=$2
. set.tempfile tmp1
<$file awk -F "\t" "BEGIN{ OFS=FS; }{ print $order; }" > $tmp1
if [ "$3" = "-w" ] ; then
    overwrite $tmp1 $file
else
    cat $tmp1
fi
