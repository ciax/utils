#!/bin/bash
# Required script: set.usage.sh
# Required packages: coreutils(basename,head,tr),grep
# make insert sentence for sql from *.csv or db-*.tsv file
[ -e "$1" ] || . set.usage "[file]"
table=$(db-table $1)
pfx="insert or ignore into $table values ("
while read line; do
    list="'${line//,/','}'"
    null="${list//\'\'/null}"
    echo "$pfx$null);"
done < <(egrep -v '^([#!].*|[[:blank:]]*)$' $1|nkf -Lu|tr $'\t' ',')
