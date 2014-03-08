#!/bin/bash
# Required packages: coreutils(sort),bsdmainutils(column)
# Required scripts: func.usage db-register
# Required tables: *
list(){
    db-register "$1"|sort|column -c${2:-50}
}
. func.usage "[table]" $1 < <(list '.tables')
list "select id from $1;" $2
