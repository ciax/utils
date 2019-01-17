#!/bin/bash
declare -A pk
while read a b; do
    if [[ $a =~ ^(ca|cert|key) ]] ; then
        pk[$a]="$b"
        echo "$a [INLINE]"
    else
        echo "$a $b" 
    fi
done
for i in ${!pk[@]}; do
    echo "<$i>"
    grep -A 100 "BEGIN" ${pk[$i]}
    echo "</$i>"
done
