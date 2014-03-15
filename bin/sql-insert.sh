#!/bin/bash
# Description: generate sql statement of insert from db-*.csv file
# Required scripts: rc.app
# Required packages: coreutils(basename,head,tr),grep
. rc.app
_usage "[tables]" $1
cd ~/db
for i;do
    table=$(show-tables $i) || { echo "No file for $1"; continue; }
    pfx="insert or ignore into $table values ("
    while read line; do
        list="'${line//,/','}'"
        null="${list//\'\'/null}"
        echo "$pfx$null);"
    done < <(egrep -hv '^([#!].*|[[:blank:]]*)$' db-$i*.csv|nkf -Lu|tr $'\t' ',')
done
