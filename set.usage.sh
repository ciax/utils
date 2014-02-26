#!/bin/bash
# Required script: set.color.sh
. set.color
[ "$1" ] || set - "(option) (lists..) < (lists..)"
CMD=${0##*/}
OPT=$1;shift
echo -e "Usage: $C3$CMD$C0 $OPT"
for i ; do
    echo -e "\t$i"
done
[ -t 0 ] || while read i; do
    echo -e "\t$i"
done
exit 2
