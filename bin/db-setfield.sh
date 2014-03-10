#!/bin/bash
# Description: Set variables corresponding field names of last table of param;
# Required scripts: func.usage, func.temp, db-register(' ')
# Required tables: *
setfield(){
    local _list
    local _id=$1;shift
    local _tbl=$1;shift
    local _sql="from $_tbl where id == '$_id'"
    for tbl; do
        _sql="from $_tbl where id == (select $_tbl $_sql)"
    done
    _sql='select * '$_sql';'
    . func.temp _list
    for i in $(db-register "pragma table_info($_tbl);"|cut -d'|' -f2);do
        read line
        echo "$i='$line'" >> $_list
    done < <(db-register "$_sql"|tr '|' '\n')
    if [[ $0 =~ db-setfield ]]; then
        cat $_list
    else
        source $_list
    fi
    rm $_list
}
set -f
if [[ $0 =~ db-setfield ]]; then
    . func.usage "[id] [table1] (table2..)" $2
elif [ "$2" ]; then
    setfield $*
fi