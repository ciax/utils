#!/bin/bash
# Required scripts: sql-make db-exec
# Required tables: mac ssl ssh
# Description: update databases
. func.getpar
opt-f(){ get=1; } # force mode
opt-b(){ bg=1; } # background mode
latest-tsv(){
    local file
    shopt -s nullglob
    for file in ~/{cfg.*,utils}/db/db-$base*.tsv;do
        stat -c%Y $file
    done|sort|tail -1
}
oldest-db(){
    local file
    for file in ~/.var/cache/db-*.sq3;do
        stat -c%Y $file
    done|sort|head -1|grep .
}
main(){
    dt=$(oldest-db) || get=1
    if [ ! "$get" ] ; then
        ct=$(latest-tsv)
        if [ "$dt" -gt "$ct" ]; then
            _comp "DB is up to date"
            return
        else
            _warn "DB($(date -d@$dt)) is older than TSV($(date -d@$ct))"
        fi
    fi
    set - $(table-ends)
    _warn "Database update for $*"
    sql-make $* gdocs|db-exec
    ssh-config -s
}
_usage
_exe_opt
[ "$bg" ] && (main > /dev/null 2>&1 &) || main
