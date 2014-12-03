#!/bin/bash
# Required packages(Debian,Raspbian,Ubuntu): sqlite3
# Required scripts: func.getpar
# Description: transaction for db file
# Usage: db-exec (opt) (sql)
#        -i:ini (a=b) style
#        -c:csv with header
. func.getpar
opt-i(){ opt=-line; }
opt-c(){ opt="-csv -header"; }
_usage "(statement)"
_exe_opt
echo "$*"
[ -d ~/.var ] || mkdir ~/.var
[[ "$VER" == *sql* ]] && opt+=" -echo"
db=~/.var/db-device.sq3
sqlite3 $opt $db ${1:+"$1"}
