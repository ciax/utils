#!/bin/bash
# Required script: set.usage.sh
# Required command: diffutils(cmp)
# Override dst_file with src_file.
# No change is no override
[ "$2" ] || . set.usage "[src_file] [dst_file]"
if cmp -s $1 $2 ; then
    rm $1;exit 1
else
    mv $1 $2
fi