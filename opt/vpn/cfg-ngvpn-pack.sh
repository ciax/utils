#!/bin/bash
declare -A pk
while read a b; do
    [[ $a =~ ^(ca|cert|key) ]] && pk[$a]="$b" || echo "$a $b" 
done
for i in ${!pk[@]}; do
    echo "<$i>"
    grep -A 100 "BEGIN" ${pk[$i]}
    echo "</$i>"
done
