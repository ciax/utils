#!/bin/bash
# Required script: set.usage, file-move
# Require command: coreutils(cat), awk
# Reorder columns except key
[ "$2" ] || . set.usage "[order(1,2,3..)] [file] (-w)"
order="\$${1//,/,\$}"
file=$2
. set.tempfile tmp1
<$file awk -F "\t" "BEGIN{ OFS=FS; }{ print $order; }" > $tmp1
if [ "$3" = "-w" ] ; then
    file-move $tmp1 $file
else
    cat $tmp1
fi
