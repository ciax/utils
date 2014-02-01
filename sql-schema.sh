#!/bin/bash
# Required script: set.usage.sh
#
## The 'id' field is automatically added to the table as 'primary key'.
## If the following 'field' content matches with a name of another 'table',
## it is treated as a "foreign key" refering to the 'id' field of the corresponding table.

schema(){
    local body="${1#db-}"
    local tbl="${body%.$ext}"
    [[ "$tables" == *$tbl* ]] && return
    tables="$tables $tbl"
    local drop="drop table if exists $tbl;"
    local create="create table $tbl ('id' primary key"
    local fkeys
    local col
    local db
    while read col other; do
        [ $col = '!id' ] && continue
        for db in *$col.$ext; do
            create="$create,'$col'"
            fkeys="$fkeys $col"
            schema $db
        done
    done < <(egrep "^!" $1|head -1|tr ',\t' $'\n')
    for i in $fkeys; do
        create="$create,foreign key('$i') references $i('id')"
    done
    echo "$drop"
    echo "$create);"
}

shopt -s nullglob
[ -e "$1" ] || . set.usage "[csv|tsv file]"
ext=${1##*.}
echo "pragma foreign_keys=on;"
schema $1
