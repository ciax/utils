#!/bin/bash
# Usage: db-files (separator)
db=~/.var/db-files.sq3
sep=${1:-,}
sqlite3 -list -separator "$sep" $db
