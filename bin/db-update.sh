#!/bin/bash
# Required scripts: sql-make db-exec
# Required tables: mac ssl ssh
# Description: update databases
. func.msg
set - $(table-ends)
_warn "Database update for $*"
sql-make $*|db-exec
