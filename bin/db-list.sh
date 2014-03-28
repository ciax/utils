#!/bin/bash
# Required packages: coreutils(sort)
# Required scripts: rc.app db-register
# Required tables: *
# Desctiption: show table list or table entry
. rc.app
_chkarg $(db-tables)
_usage "[table]"
db-register "select id from $1;"|sort
