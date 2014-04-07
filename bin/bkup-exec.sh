#!/bin/bash
# Required commands: sqlite3
# Required scripts: func.getpar
# Description: transaction for file history
# Usage: bkup-exec (separator)
. func.getpar
_usage "(statement)" || exit 1
db=~/.var/bkup.sq3
sqlite3 -csv $db ${1:+"$1"}
