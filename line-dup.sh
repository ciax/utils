#!/bin/bash
# Required script: usage.sh
# Required packages: coreutils(sort,nkf,uniq)
# Pick up duplicated lines
#alias dup
[ -t 0 ] && . func.usage " < [files]"
prev=''
while read line;do
    [ "$line" = "$prev" ] && echo $line
    prev=$line
done < <(nkf -d|sort) | uniq
