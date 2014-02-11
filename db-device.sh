#!/bin/bash
# Usage: db-device (separator)
db=~/.var/db-device.sq3
sep=${1:-,}
sqlite3 -list -separator "$sep" $db
