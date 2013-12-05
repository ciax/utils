#!/bin/bash
# Required script: set.usage.sh, db-expand.pl
#  schema file (sc-*.tsv) contains 'table' and 'field' separated by <tab>
#  The primary key 'id' is automatically added to each tables.
#  If a 'field' content matches with a name of another 'table',
#  it is treated as a "foreign key" refering to the 'id' field of the table.
#  So the refered table must be shown above those field of line.
[ -e "$1" ] || . set.usage "[schema tsv file]"
echo "begin;"
echo "pragma foreign_keys=on;"
while read tbl fld; do
    if [ "$table" != "$tbl" ]; then
        create="$create$rstr"
        [ "$create" ] && create="$create);\n"
        table=$tbl
        tables="$tables $tbl"
        echo "drop table if exists $tbl;"
        create="${create}create table $tbl ('id' primary key"
        rstr=
    fi
    create="$create,'$fld'"
    case "$tables" in
        *$fld*) rstr="$rstr,foreign key('$fld') references $fld('id')";;
        *);;
    esac
done < <(db-expand $1)
# Process Substitution makes the internal(while do) var effective at outside of that
echo -en $create
echo ");"
echo "commit;"
