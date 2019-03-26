#!/bin/bash
# Required packages: nkf
# Required scripts: func.getpar table-core
# Description: generate sql statement of insert from db-*.tsv file
. func.getpar
_usage "[tables] .."
for i;do
    table=$(table-core $i) || continue # File exists?
    while read line; do
        echo "insert or ignore into $i values ('$line');"
    done < <(egrep -hv '^([#!].*|[[:blank:]]*)$' db-$i*.tsv| sed -e "s/\t/','/g") | sed -e "s/''/null/g"
done
