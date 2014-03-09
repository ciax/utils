#!/bin/bash
# Description: Set variables corresponding field names of table;
# Required scripts: func.usage, func.temp, db-register
# Required tables: *
trackdb(){
    db-register -i "$1" > $db
    if [ -s $db ] ; then
        while read var eq str;do
            [ "$2" ] && str=''
            eval "$var='$str'"
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
    . func.temp db
    trackdb "$sql"
    rm $db
}
set -f
. func.usage "[id] [table1] (table2..)" $2
getvar $*
[[ $0 =~ set.field ]] && {  set|egrep '^[a-z]+='; }
