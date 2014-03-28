#!/bin/bash
# Required packages: coreutils(sort)
# Required scripts: rc.app db-register
# Required tables: *
# Desctiption: show table list or table entry
. rc.app
list(){
    db-register "$1"|sort
}
_chkarg $(list '.tables')
set - "$ARGV"
_usage "[table]" $1
list "select id from $1;" $2
