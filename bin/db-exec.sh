#!/bin/bash
# Required packages: sqlite3
# Required scripts: func.getpar
# Description: transaction for db file
# Usage: db-exec (opt) (sql)
#        -i:ini (a=b) style
. func.getpar
opt=-csv
opt-i(){ opt=-line; }
_usage "(statement)"
db=~/.var/db-device.sq3
sqlite3 $opt $db ${1:+"$1"}
