#!/bin/bash
# Required packages(Debian,Raspbian,Ubuntu): sqlite3
# Required scripts: func.getpar
# Description: transaction for db file
# Usage: db-exec (opt) (sql)
. func.getpar
opt-i(){ opt=-line; } #ini (a=b) style
opt-c(){ opt=-csv; } #csv
opt-h(){ opt=-header; } #header
_usage "(statement)"
_exe_opt
[[ "$VER" == *sql* ]] && opt+=" -echo"
db=~/.var/cache/db-device.sq3
sqlite3 $opt $db ${1:+"$1"}
