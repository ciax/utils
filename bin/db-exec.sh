#!/bin/bash
# Required commands: sqlite3
# Required scripts: func.app
# Description: transaction for db file
# Usage: db-exec (opt) (sql)
#        -i:ini (a=b) style
. func.app
opt-i(){ opt=-line; }
_usage "(statement)"
db=~/.var/db-device.sq3
sqlite3 $opt $db ${1:+"$1"}
