#!/bin/bash
# Required scripts: sql-make db-exec
# Required tables: mac ssl ssh
# Description: update databases
. func.getpar
opt-f(){ get=1; } # force mode
latest-tsv(){
    local file
    shopt -s nullglob
    for file in ~/{cfg.*,utils}/db/db-$base*.tsv;do
        stat -c%Y $file
    done|sort|tail -1
}
oldest-db(){
    local file
    for file in ~/.var/db-*.sq3;do
        stat -c%Y $file
    done|sort|head -1|grep .
}
_usage
_exe_opt
dt=$(oldest-db) || get=1
if [ ! "$get" ] ; then 
    ct=$(latest-tsv)
    if [ "$dt" -gt "$ct" ]; then
        _warn "DB is up to date"
        exit
    else
        _warn "DB($(date -d@$dt)) is older than TSV($(date -d@$ct))"
    fi
fi
set - $(table-ends)
_warn "Database update for $*"
sql-make $*|db-exec
cfg-hosts -s
ssh-config -s
