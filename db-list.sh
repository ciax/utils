#!/bin/bash
# Required Packages: bsdmainutils(column)
list(){
    db-register <<< "$1"|sort|column -c${2:-50}
}
[ "$1" ] || . set.usage "[table]" < <(list '.tables')
list "select id from $1;" $2
