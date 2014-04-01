#!/bin/bash
# Required packages: sqlite3
# Description: transaction for file history
# Usage: bkup-exec (separator)
. func.app
_usage || exit 1
db=~/.var/bkup.sq3
sqlite3 -csv $db ${1:+"$1"}
