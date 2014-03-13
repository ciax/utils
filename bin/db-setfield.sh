#!/bin/bash
# Required scripts: func.usage, func.temp, db-register(' ')
# Required tables: *
# Description: Set variables corresponding field names of last table of param;
#  default reference key(search key) name is 'id'
setfield(){
    local _list
    local _wh
    local _key=$1;shift
    local _tbl=$1;shift
    IFS=,
    for _i in $_key;do
        if [[ $_i =~ = ]]; then
            local _fld=${_i%=*}
            local _val=${_i#*=}
        else
            local _fld='id'
            local _val=$_i
        fi
        _wh="${_wh:+$_wh and} $_fld == '$_val'"
    done
    unset IFS
    local _sql="from $_tbl where$_wh"
    for _tbl; do
        _sql="from $_tbl where id == (select $_tbl $_sql)"
    done
    _sql='select * '$_sql';'
    . func.temp _list
    for _i in $(db-register "pragma table_info($_tbl);"|cut -d'|' -f2);do
        read _line
        echo "$_i='$_line'" >> $_list
    done < <(db-register "$_sql"|tr '|' '\n')
    if [[ $0 =~ db-setfield ]]; then
        echo $_sql
        cat $_list
    else
        source $_list
    fi
    rm $_list
}
set -f
if [[ $0 =~ db-setfield ]]; then
    . func.usage "[id | key=a,key=b..] [table1] (table2..)" $2
    setfield $*
elif [ "$2" ]; then
    setfield $*
fi