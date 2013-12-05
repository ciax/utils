#!/bin/bash
#schema file (sc-*.tsv) contains 'table' and 'field' separated by <tab>
#The primary key 'id' is automatically added to each tables.
#If a 'field' content matches with a name of another 'table',
#it is treated as a "foreign key" refering to the 'id' field of the table.
#So the refered table must be shown above those field of line.
[ -e "$1" ] || { echo "Usage: ${0##*/} [schema tsv file]"; exit; }
. set.tempfile drop create rstr
egrep -v '^([#!].*|$)' $1|while read tbl fld; do
if [ "$table" != "$tbl" ]; then
    cat $rstr >> $create
    [ -s $create ] && echo ");" >> $create
    table=$tbl
    tables="$tables $tbl"
    echo "drop table if exists $tbl;" >> $drop
    echo -n "create table $tbl ('id' primary key" >> $create
    echo -n '' > $rstr
fi
echo -n ",'$fld'" >> $create
case "$tables" in
    *$fld*) echo -n ",foreign key('$fld') references $fld('id')" >> $rstr;;
    *);;
esac
done
echo "begin;"
echo "pragma foreign_keys=on;"
cat $drop
cat $create
echo ");"
echo "commit;"
