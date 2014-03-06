#!/bin/bash
# Required script: set.usage
# Required packages: coreutils(basename,head,tr),grep
# make insert sentence for sql from *.csv or db-*.tsv file
. set.usage "[file]" $1
table=$(db-table $1)
pfx="insert or ignore into $table values ("
while read line; do
    list="'${line//,/','}'"
    null="${list//\'\'/null}"
    echo "$pfx$null);"
done < <(egrep -v '^([#!].*|[[:blank:]]*)$' $1|nkf -Lu|tr $'\t' ',')
