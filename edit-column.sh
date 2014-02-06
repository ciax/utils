#!/bin/bash
# Required script: set.usage, set.tempfile
# Required packages: coreutils(cat),mawk
# Reorder columns except key
[ "$2" ] || . set.usage "[order(1,2,3..)] [file] (-w)"
order="\$${1//,/,\$}"
file=$2
. set.tempfile tmp1
<$file awk -F "\t" "BEGIN{ OFS=FS; }{ print $order; }" > $tmp1
if [ "$3" = "-w" ] ; then
    overwrite $tmp1 $file
else
    cat $tmp1
fi
