#!/bin/bash
# Required commands: nkf
# Required scripts: func.app,show-tables
# Description: generate sql statement of insert from db-*.csv file
. func.app
_usage "[tables]"
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
