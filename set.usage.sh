#!/bin/bash
# Required script: set.color.sh
. set.color
[ "$1" ] || set - "(option)" "lists.."
CMD=${0##*/}
OPT=$1;shift
echo -e "Usage: $C3$CMD$C0 $OPT";shift
for i; do
    echo -e "\t$i"
done
exit 2
