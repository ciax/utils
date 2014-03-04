#!/bin/bash
[ "$1" ] || . set.usage "[tables]"
files=''
for tbl;do
    set - ~/db/db-$tbl.?sv
    [ -s "$1" ] || continue
    files="$files $1"
done
ext=${files##*.}
. set.tempfile sch
echo "begin;"
sql-schema $files|tee $sch
for tbl in $(grep '^drop' $sch|tr -d ';'|cut -d' ' -f5);do
    for i in ~/db/db-$tbl*.$ext; do
        sql-insert $i
    done
done
echo "commit;"
