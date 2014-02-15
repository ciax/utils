#!/bin/bash
# Required script: set.color.sh
# std input makes list
. set.color
[ "$1" ] || set - "No input"
echo -e "${C1} ERROR:$C3 $1$C0"
shift
for i; do
    echo -e "\t$i"
done
exit 1
