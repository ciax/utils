#!/bin/bash
# Required packages: bsdmainutils(column)
list(){
    db-register "$1"|sort|column -c${2:-50}
}
. func.usage "[table]" $1 < <(list '.tables')
list "select id from $1;" $2
