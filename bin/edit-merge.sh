#!/bin/bash
# Required packages: nkf
# Required scripts: func.getpar
# Description: merge files with sorting and remove duplicated lines
#   If no changes, then no rewrite
. func.getpar
_usage "[file] (input)"
file=$1;shift
[ -f "$file" ] || touch $file
[ -w "$file" ] || _abort "Permission denied [$file]"
{ nkf -d "$file";cat $1; } | sort -u | _overwrite $file && echo "$file was updated"
