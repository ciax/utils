#!/bin/bash
[ "$1" ] || . set.usage "[table]"
set - ~/db/db-$1.?sv
[ -s "$1" ] || exit;
ext=${1##*.}
. set.tempfile sch
echo "begin;"
sql-schema $1|tee $sch
for tbl in $(grep '^drop' $sch|tr -d ';'|cut -d' ' -f5);do
    for i in ~/db/db-$tbl*.$ext; do
        sql-insert $i
    done
done
echo "commit;"
