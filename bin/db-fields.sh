#!/bin/bash
# Required scripts: rc.app, db-exec
# Required tables: *
# Description: Show field names
. rc.app
_chkarg $(db-tables)
_usage "[table1]"
db-exec "pragma table_info($1);"|cut -d'|' -f2
