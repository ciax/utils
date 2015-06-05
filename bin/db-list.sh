#!/bin/bash
# Required scripts: func.getpar db-tables db-exec
# Required tables: *
# Desctiption: show table list or table entry
. func.getpar
_usage "[table] (field(=cond))" $(db-tables)
tbl=$1;shift
_temp _tmp_tbl
db-exec "select id from $tbl;"|grep . > $_tmp_tbl || { db-tables; exit 1; }

case "$1" in
    *=*)
        whr="where ${1%=*} = '${1#*=}'"
        db-exec "select id from $tbl $whr;"|grep .|sort -u
        ;;
    '')
        cat $_tmp_tbl
        ;;
    *)
        {
            db-exec "select $1 from $tbl;" ||\
                db-exec "pragma table_info($tbl);"
        } | grep .| sort -u
        ;;
esac
