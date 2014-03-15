#!/bin/bash
# Required scripts: rc.app, db-register
# Required tables: *
# Description: Show field names
. rc.app
_usage "[table1]" $1
db-register "pragma table_info($1);"|cut -d'|' -f2
