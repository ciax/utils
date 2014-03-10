#!/bin/bash
# Description: Set variables corresponding field names of last table of param;
# Required scripts: func.usage, func.temp, db-register(' ')
# Required tables: *
setfield(){
    local id=$1;shift
    local tbl=$1;shift
    local sql="from $tbl where id == '$id'"
    for tbl; do
        sql="from $tbl where id == (select $tbl $sql)"
    done
    sql='select * '$sql';'
    . func.temp list
    for i in $(db-register "pragma table_info($tbl);"|cut -d'|' -f2);do
        read line
        echo "$i='$line'" >> $list
    done < <(db-register "$sql"|tr '|' '\n')
    if [[ $0 =~ db-setfield ]]; then
        cat $list
    else
        source $list
    fi
    rm $list;unset list
}
set -f
if [[ $0 =~ db-setfield ]]; then
    . func.usage "[id] [table1] (table2..)" $2
elif [ "$2" ]; then
    setfield $*
fi