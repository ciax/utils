#!/bin/bash
# Required packages: nkf
# Required scripts: func.getpar table-core
# Description: generate sql statement for create table

# TSV file rule:
#  The file location:  ~/utils/db/db-(table name).tsv
#  Field string format: "!name", "*name" "name*table:key"
#    ! : if the field string has '!', it is 'primary key'.
#    name : treated as field name, if name have prefix of '*',
#           it is treated as a refarence table name of the 'foreign key'
#    table : you can specify the refarence table instead of the 'name'.
#    key : reference key can be specified, otherwise 'id' will be used.
#    The available charactors for 'field name' are [a-zA-Z0-9] and '_'
. func.getpar
schema(){
    local tbl=$(table-core $1) || return 1 #return if file dosn't exist
    [[ "$tables" =~ $tbl ]] && return
    tables="$tables $tbl"
    local drop="drop table if exists $tbl;"
    local create="create table $tbl ("
    local pkeys='' # primary keys
    local fkeys='' # foreign keys
    _temp tmpline
    egrep "^!" db-$tbl.tsv|head -1|tr ",\t" "\n" > $tmpline
    while read col; do
        # Add to Primary key list
        case "$col" in
            !*)
                local field=${col#!}
                pkeys="${pkeys:+$pkeys,}$field"
                ;;
            *"*"*)
                # Add to Refence key list
                local ref=${col#*\*}
                local field=${col%\**}
                field=${field:-$ref}
                # ref -> rtable, rkey
                local rtable="${ref%:*}";rtable=${rtable:-$field} 
                if [[ $ref =~ ':' ]]; then 
                    local rkey="${ref#*:}"
                else
                    local rkey="id"
                fi
                for rfile in $(table-core $rtable); do
                    fkeys="$fkeys,foreign key('$field') references $rfile('$rkey')"
                    reftbl="$reftbl $rfile"
                    schema $rfile
                done
                ;;
            *)
                local field=$col
                ;;
        esac
        create="$create'$field',"
    done < $tmpline
    echo "$drop"
    echo $create"primary key($pkeys)$fkeys);"
}
shopt -s nullglob
_usage "[table] .."
cd ~/utils/db
tables=''
echo "pragma foreign_keys=on;"
for i; do
    schema $i
done
