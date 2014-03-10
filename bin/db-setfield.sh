#!/bin/bash
# Description: Set variables corresponding field names of last table of param;
# Required scripts: func.usage, func.temp, db-register(' ')
# Required tables: *
getvar(){
    local id=$1;shift
    local tbl=$1;shift
    local sql="from $tbl where id == '$id'"
    for tbl; do
        sql="from $tbl where id == (select $tbl $sql)"
    done
    sql='select * '$sql';'
    for i in $(db-register "pragma table_info($tbl);"|cut -d'|' -f2);do
        read line
        echo "$i='$line'" >> $list
    done < <(db-register "$sql"|tr '|' '\n')
    source $list
}
. func.usage "[id] [table1] (table2..)" $2
. func.temp db list
getvar $*
[[ $0 =~ db-setfield ]] && {  cat $list; }
