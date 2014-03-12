#!/bin/bash
# Description: generate sql statement for create table
# Required scripts: func.usage
# Required packages: coreutils(dirname,basename,head,tr),grep,nkf

# CSV file rule:
#  The file location:  ~/utils/db/db-(table name).csv
#  The 'field name' having '!' will be 'primary key'.
#  If the 'field name' matches with 'table name' of another file,
#  it is treated as a 'foreign key' refering to the 'id' field of the corresponding table.
#  The 'field name' has to contain [a-zA-Z0-9] and '_'

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

