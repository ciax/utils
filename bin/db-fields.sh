#!/bin/bash
# Required scripts: src.app, db-exec
# Required tables: *
# Description: Show field names
. src.app
_chkarg $(db-tables)
_usage "[table1]"
db-exec "pragma table_info($1);"|cut -d'|' -f2
