#!/bin/bash
# Usage: db-register (separator)
db=~/.var/db-register.sq3
sep=${1:-,}
sqlite3 -list -separator "$sep" $db
