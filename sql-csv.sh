#!/bin/bash
# Required script: set.usage.sh
#
## The 'id' field is automatically added to the table as 'primary key'.
## If the following 'field' content matches with a name of another 'table',
## it is treated as a "foreign key" refering to the 'id' field of the corresponding table.
## So the refered table must be shown above those field of line.

[ -e "$1" ] || . set.usage "[csv file]"
schema(){
    local tbl="${1%.csv}"
    [[ "$tables" == *$tbl* ]] && return
    tables="$tables $tbl"
    local drop="drop table if exists $tbl;"
    local create="create table $tbl ('id' primary key"
    local fkeys
    while read col; do
        local db="$col.csv"
        [ $col = '!id' ] && continue
        create="$create,'$col'"
        if [ -e "$db" ] ; then
            fkeys="$fkeys $col"
            schema $db
        fi
    done < <(egrep "^!" $1|head -1|tr ',' $'\n')
    for i in $fkeys; do
        create="$create,foreign key('$i') references $i('id')"
    done
    echo "$drop"
    echo "$create);"
}
insert(){
    pfx="insert or ignore into $1 values ('"
    while read line ;do
        echo "$pfx${line//,/','}');"
    done < <(egrep -v '^([#!].*|[	 ]*)$' $1.csv)
}
echo "begin;"
echo "pragma foreign_keys=on;"
schema $1
for tbl in $tables; do
    insert $tbl
done
echo "commit;"

