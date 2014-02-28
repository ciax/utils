#!/bin/bash
# Usage: db-register (opt) (sql)
#    -s:space separator
#    -i:ini (a=b) style
db=~/.var/db-register.sq3
case "$1" in
    -s) shift;opt="-separator ' '";;
    -i) shift;opt="-line";;
    *) opt="-separator ,";;
esac
sqlite3 $opt $db ${1:+"$1"}
