#!/bin/bash
# Required scripts: func.getpar db-tables db-exec
# Required tables: *
# Description: Show field names
. func.getpar
_usage "[table1]" < <(db-tables)
db-exec "pragma table_info($1);"|cut -d',' -f2
