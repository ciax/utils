#!/bin/bash
#alias depr |dep-tree
# Description: show ruby script dependency list
while read line; do
    echo "${line##* } ${line%.*}"
done < <(egrep -H "^require" ${*:-*.rb}|tr -d "'")|sort -u
