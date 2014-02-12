#!/bin/bash
[ "$1" ] || . set.usage "[csv|tsv file]"
set - ~/cfg.*/db/*${1%;}.?sv
[ -s "$1" ] || exit;
ext=${1##*.}
. set.tempfile sch
echo "begin;"
sql-schema $1|tee $sch
while read a b c d name; do
    for i in ~/cfg.*/db/*${name%;}.$ext; do
        sql-insert $i
    done
done < <(grep '^drop' $sch)
echo "commit;"
