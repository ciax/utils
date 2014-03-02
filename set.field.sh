#!/bin/bash
# Set variables corresponding field names of table;
set -f
[ "$2" ] || . set.usage "[id] [table1] (table2..)"
case $0 in
    *set.field*) cmd='echo';;
    *) cmd='eval';;
esac
val=$1;shift
ptbl=$1;shift
sub="from $ptbl where id == '$val'"
for tbl; do
    sub="from $tbl where id == (select $tbl $sub)"
done
sub="select * $sub;"
while read var eq str;do
    $cmd "$var='$str'"
done < <(db-register -i "$sub")
