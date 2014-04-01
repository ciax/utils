#!/bin/bash
# Required packages: coreutils(sort)
# Required scripts: src.app db-exec
# Required tables: *
# Desctiption: show table list or table entry
. src.app
_chkarg $(db-tables)
_usage "[table]"
db-exec "select id from $1;"|sort
