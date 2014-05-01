#!/bin/bash
# Required packages: nkf
# Required scripts: func.getpar table-core
# Description: generate sql statement for create table

# CSV file rule:
#  The file location:  ~/utils/db/db-(table name).csv
#  Field string format: !name(table:key)
#    ! : if the field string has '!', it is 'primary key'.
#    name : treated as field name, if this matches with 'table name' of another file,
#           it is treated as a refarence table name of the 'foreign key'
#    table : you can specify the refarence table instead of the 'name'.
#    key : reference key can be specified, otherwise 'id' will be used.
#    The available charactors for 'field name' are [a-zA-Z0-9] and '_'
. func.getpar
schema(){
    local tbl=$(table-core $1) || return 1
    [[ "$tables" =~ $tbl ]] && return
    tables="$tables $tbl"
    local drop="drop table if exists $tbl;"
    local create="create table $tbl ("
    local pkeys=''
    local fkeys=''
    while read col; do
        local field="${col%(*}"
        if [[ $field =~ '!' ]] ; then
            field=${field#!}
            pkeys="${pkeys:+$pkeys,}$field"
        fi
        local ref="${col#*(}";ref="${ref%)*}"
        local rtable="${ref%:*}";rtable=${rtable:-$field}
        if [[ $ref =~ ':' ]]; then
            local rkey="${ref#*:}"
        else
            local rkey="id"
        fi
        create="$create'$field',"
        for rfile in $(table-core $rtable); do
            fkeys="$fkeys,foreign key('$field') references $rfile('$rkey')"
            reftbl="$reftbl $rfile"
            schema $rfile
        done
    done < <(egrep "^!" db-$tbl.csv|head -1|nkf -Lu|tr ",\t" "\n")
    echo "$drop"
    echo $create"primary key($pkeys)$fkeys);"
}
shopt -s nullglob
_usage "[table] .."
tables=''
echo "pragma foreign_keys=on;"
for i; do
    schema $i
done
