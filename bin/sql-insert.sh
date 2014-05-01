#!/bin/bash
# Required packages: nkf
# Required scripts: func.getpar table-core
# Description: generate sql statement of insert from db-*.csv file
. func.getpar
_usage "[tables]"
for i;do
    table=$(table-core $i) || continue
    pfx="insert or ignore into $table values ('"
    while read line; do
        line=$pfx${line//,/"','"}"');"
        echo "${line//"''"/null}"
    done < <(egrep -hv '^([#!].*|[[:blank:]]*)$' db-$i*.csv|nkf -Lu)
done
