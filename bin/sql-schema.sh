#!/bin/bash
# Description: generate sql statement for create table
# Required scripts: func.usage
# Required packages: coreutils(dirname,basename,head,tr),grep,nkf
## CSV files: ~/db/db-*.csv
## The 'id' field is automatically added to the table as 'primary key'.
## If the following 'field' content matches with a name of another 'table',
## it is treated as a "foreign key" refering to the 'id' field of the corresponding table.
schema(){
    local tbl=$(show-tables $1) || return 1
    [[ "$tables" =~ $tbl ]] && return
    tables="$tables $tbl"
    local drop="drop table if exists $tbl;"
    local create="create table $tbl ("
    local pkeys=''
    local fkeys=''
    while read col; do
        if [[ $col =~ '!' ]] ; then
            col=${col#!}
            pkeys="${pkeys:+$pkeys,}$col"
        fi
        create="$create'$col',"
        for ref in $(show-tables $col); do
            fkeys="$fkeys,foreign key('$ref') references $ref('id')"
            reftbl="$reftbl $ref"
            schema $ref
        done
    done < <(egrep "^!" db-$tbl.csv|head -1|nkf -Lu|tr ",\t" "\n")
    echo "$drop"
    echo $create"primary key($pkeys)$fkeys);"
}
shopt -s nullglob
. func.usage "[table] .." $1
tables=''
echo "pragma foreign_keys=on;"
cd ~/db
for i; do
    schema $i
done

