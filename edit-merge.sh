#!/bin/bash
# Required script: usage.sh, set.tempfile.sh
# Required command: coreutils(sort,nkf,cp,cmp)
# Merge files with sorting and without duplicated lines
# If no changes, then no rewrite
[ "$2" ] || . set.usage "[src_file|-] [dst_file]"
. set.tempfile tmd tms
src="$1";shift
dst="$1";shift
if [ "$src" = "-" ] ; then
    nkf -d > $tms
elif [ -f "$src" ] ; then
    cp "$src" $tms
else
    echo "No such file $src"
    exit 1
fi
[ -f "$dst" ] || touch $dst
nkf -d "$dst" >> $tms
<$tms sort -u > $tmd
if ! cmp -s $tmd $dst ; then
    [ -w "$dst" ] || { echo "Permission denied $dst"; exit; }
    cat $tmd > $dst
    echo "$dst is updated"
fi
