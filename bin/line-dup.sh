#!/bin/bash
#alias dup
# Required packages: nkf
# Required scripts: func.getpar
# Description: Pick up duplicated lines
. func.getpar
_usage "<files>"
prev=''
while read line;do
    [ "$line" = "$prev" ] && echo $line
    prev=$line
done < <(nkf -d $*|sort) | uniq
