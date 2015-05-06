#!/bin/bash
# Required scripts: func.getpar db-tables db-exec
# Required tables: *
# Desctiption: show table list or table entry
. func.getpar
_usage "[table]" < <(db-tables)
db-exec "select id from $1;"|grep .
