#!/bin/bash
# Required packages: coreutils(sort),bsdmainutils(column)
# Required scripts: rc.app db-register
# Required tables: *
# Desctiption: show table list or table entry
. rc.app
list(){
    db-register "$1"|sort|column -c${2:-50}
}
_usage "[table]" $1 < <(list '.tables')
list "select id from $1;" $2
