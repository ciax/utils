#!/bin/bash
# Required scripts: func.usage, db-register
# Required tables: *
# Description: Show field names
. func.usage "[table1]" $1
db-register "pragma table_info($1);"|cut -d'|' -f2
