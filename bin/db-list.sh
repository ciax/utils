#!/bin/bash
# Required commands: sort
# Required scripts: func.app,db-tables,db-exec
# Required tables: *
# Desctiption: show table list or table entry
. func.app
_usage "[table]" $(db-tables)
db-exec "select id from $1;"|sort
