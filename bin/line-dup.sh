#!/bin/bash
#alias dup
# Required scripts: func.app
# Required packages: coreutils(sort,nkf,uniq)
# Description: Pick up duplicated lines
. func.app
[ -t 0 ] && _usage " < [files]"
prev=''
while read line;do
    [ "$line" = "$prev" ] && echo $line
    prev=$line
done < <(nkf -d|sort) | uniq
