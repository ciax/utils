#!/bin/bash
# Required scripts: rc.app, db-exec, db-fields
# Required tables: *
# Description: Set variables corresponding field names of last table of param;
#     default reference key(search key) name is 'id'
#     if key is specified, null value is also matched as default key;
. rc.app
resetfield(){
    for j;do
        for i in $(db-fields $j); do
            unset $i
        done
    done
}
setfield(){
    local _wh
    local _key=$1;shift
    local _tbl=$1;shift
    IFS=,
    for _i in $_key;do
        if [[ $_i =~ = ]]; then
            local _fld=${_i%=*}
            local _val=${_i#*=}
            local _exp="($_fld is null or $_fld == '$_val')"
        else
            local _fld='id'
            local _val=$_i
            local _exp="$_fld == '$_val'"
        fi
        _wh="${_wh:+$_wh and} $_exp"
    done
    unset IFS
    local _sql="from $_tbl where$_wh"
    for _tbl; do
        _sql="from $_tbl where id == (select $_tbl $_sql)"
    done
    _sql='select * '$_sql';'
    echo -n > $_list
    while read _key _eq _val;do
        [ "$_val" ] && echo "$_key='$_val'" >> $_list
    done < <(db-exec -i "$_sql")
    if [ "$VER" ] || [[ $0 =~ db-setfield ]]; then
        echo $_sql
        cat $_list
    fi
    source $_list
    [ -s $_list ]
}
set -f
[[ $0 =~ db-setfield ]] && _usage "[id | key=a,key=b..]" "[table1] (table2..)"
_temp _list
[ "$2" ] && setfield $*
