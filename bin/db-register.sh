#!/bin/bash
# Required packages: sqlite3
# Description: transaction for db file
# Usage: db-register (opt) (sql)
#        -i:ini (a=b) style
[ "$1" = -i ] && { opt=-line;shift; }
db=~/.var/db-register.sq3
sqlite3 $opt $db ${1:+"$1"}
