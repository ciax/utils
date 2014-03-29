#!/bin/bash
# Required packages: coreutils(sort)
# Required scripts: rc.app db-exec
# Required tables: *
# Desctiption: show table list or table entry
. rc.app
_chkarg $(db-tables)
_usage "[table]"
db-exec "select id from $1;"|sort
