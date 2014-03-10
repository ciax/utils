#!/bin/bash
# Description: Set variables corresponding field names of table;
# Required scripts: func.usage, func.temp, db-register
# Required tables: *
trackdb(){
    db-register -i "$1" > $db
    if [ -s $db ] ; then
        while read var eq str;do
            [ "$2" ] && str=''
            echo "$var='$str'" >> $list
        done < $db
    else
        trackdb "select * from $tbl where id == (select min(id) from $tbl)" unset
    fi
}
getvar(){
    local sql="from $2 where id == '$1'"
    shift;shift
    for tbl; do
        sql="from $tbl where id == (select $tbl $sql)"
    done
    sql="select * $sql;"
    trackdb "$sql"
    source $list
}
set -f
. func.usage "[id] [table1] (table2..)" $2
. func.temp db list
getvar $*
[[ $0 =~ db-setfield ]] && {  cat $list; }
