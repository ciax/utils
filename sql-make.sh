#!/bin/bash
[ "$1" = "-i" ] && { shift; exec 1> >(db-device); }
[ -e "$1" ] || . set.usage "(-i:input) [csv|tsv file]"
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
