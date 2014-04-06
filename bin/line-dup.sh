#!/bin/bash
#alias dup
# Required commands: nkf
# Required scripts: func.app
# Description: Pick up duplicated lines
. func.app
_usage "<files>"
prev=''
while read line;do
    [ "$line" = "$prev" ] && echo $line
    prev=$line
done < <(nkf -d $*|sort) | uniq
