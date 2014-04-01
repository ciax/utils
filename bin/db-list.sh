#!/bin/bash
# Required packages: coreutils(sort)
# Required scripts: func.app db-exec
# Required tables: *
# Desctiption: show table list or table entry
. func.app
_chkarg $(db-tables)
_usage "[table]"
db-exec "select id from $1;"|sort
