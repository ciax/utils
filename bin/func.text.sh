#!/bin/bash

_text-dup(){ # Pick up duplicated lines
    local prev=''
    while read line;do
	[ "$line" = "$prev" ] && echo $line
	prev=$line
    done < <(nkf -d $*|sort) | uniq
}
