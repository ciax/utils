#!/bin/bash
# Required packages: sqlite3
# Description: transaction for file history
# Usage: bkup-sqlite (separator)
db=~/.var/bkup-sqlite.sq3
sep=${1:-,}
sqlite3 -list -separator "$sep" $db
