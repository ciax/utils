#!/bin/bash
# Description: merge files with sorting and remove duplicated lines
#   If no changes, then no rewrite
# Required scripts: func.usage, func.temp
# Required packages: coreutils(sort,nkf,cp,cmp)
. func.usage "[file] (input)" $1
file=$1;shift
[ -f "$file" ] || touch $file
[ -w "$file" ] || abort "Permission denied [$file]"
. func.temp temp
{ nkf -d "$file";cat $1; } | sort -u > $temp
overwrite $temp $file && echo "$file was updated"
