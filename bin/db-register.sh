#!/bin/bash
# Description: transaction for db file
# Required packages: sqlite3
# Usage: db-register (opt) (sql)
#    -i:ini (a=b) style
db=~/.var/db-register.sq3
sqlite3 $db ${1:+"$1"}
