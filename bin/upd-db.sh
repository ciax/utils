#!/bin/bash
# Required scripts: sql-make, db-exec
# Required tables: mac,ssl,ssh
# Description: update databases
cd ~/db
set - $(show-tables -i)
echo $C3"Database update for $*"$C0
sql-make $*|db-exec
