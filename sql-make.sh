#!/bin/bash
[ "$1" = "-s" ] && { shift; show=1; }
[ -e "$1" ] || . set.usage "(-s:show) [csv|tsv file]"
db=~/.var/db-device.sq3
[ "$show" ] || exec 1> >(sqlite3 $db)
ext=${1##*.}
. set.tempfile sch
echo "begin;"
sql-schema $1|tee $sch
while read a b c d name; do
    for i in *${name%;}.$ext; do
        sql-insert $i
    done
done < <(grep '^drop' $sch)
echo "commit;"
