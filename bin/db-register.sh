#!/bin/bash
# Usage: db-register (opt) (sql)
#    -i:ini (a=b) style
# Required packages: sqlite3
db=~/.var/db-register.sq3
[ "$1" = -i ] && { shift;opt="-line"; }
sqlite3 -separator ' ' $opt $db ${1:+"$1"}
