#!/bin/bash
# Required scripts: func.app, db-exec
# Required tables: *
# Description: Show field names
. func.app
_usage "[table1]" $(db-tables)
db-exec "pragma table_info($1);"|cut -d'|' -f2
