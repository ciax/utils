#!/bin/bash
# Required commands: touch,sort,nkf,cat
# Required scripts: func.app
# Description: merge files with sorting and remove duplicated lines
#   If no changes, then no rewrite
. func.app
_usage "[file] (input)"
file=$1;shift
[ -f "$file" ] || touch $file
[ -w "$file" ] || _abort "Permission denied [$file]"
_temp temp
{ nkf -d "$file";cat $1; } | sort -u > $temp
_overwrite $temp $file && echo "$file was updated"
