#!/bin/bash
# Description: transaction for file history
# Required packages: sqlite3
# Usage: db-files (separator)
db=~/.var/db-files.sq3
sep=${1:-,}
sqlite3 -list -separator "$sep" $db
