#!/bin/bash
# Required scripts: func.getpar db-exec
# Required tables: *
# Description: Print fields corresponding field names of last table of param;
#     The default reference key(search key) is 'id';
#     Also multiple keys are available (these must be primary keys);
#     In the multiple key, null value is matched as a default value;
. func.getpar
cond(){
    for i
    do
        if [[ $i =~ = ]];then
            set - "${i//=/ }"
            echo -n "${con}($1 is null or $1 == '$2')"
        else
            echo -n "${con}id == '$i'"
        fi
        con=" and "
    done
}

traceback(){
    local key=$1;shift
    local tbl=$1;shift
    local sql="from $tbl where $(IFS=,;cond $key)"
    for tbl
    do
        sql="from $tbl where id == (select $tbl $sql)"
    done
    sql='select * '$sql';'
    while read key eq val; do
        [ "$val" ] && echo "$key='$val'"
    done < <(db-exec -i "$sql")
}
_usage "[(id=)val | key=val,key=val..] [table1] (table2..)"
traceback $*
