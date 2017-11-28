#!/bin/bash
# Required packages(Debian,Raspbian,Ubuntu): sqlite3
# Required scripts: func.getpar
# Description: transaction for file history
# Usage: bkup-exec (separator)
. func.getpar
_usage "(statement)"
db=~/.var/log/bkup.sq3
sqlite3 $db ${1:+"$1"}
