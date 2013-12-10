#!/bin/bash
[ "$1" ] && exec 1> >(sqlite3 $1)
cd ~/db
echo "begin;"
sql-schema sch-device.tsv
while read name other; do
    file="db-$name.tsv"
    [ -e "$file" ] && sql-insert $file
done < <(grep '^[a-z]' sch-device.tsv)
echo "commit;"