#!/bin/bash
# Description: update databases
# Required scripts: sql-make, db-register
# Required tables: mac,ssl,ssh
cd ~/db
set - $(show-tables -i)
echo $C3"Database update for $*"$C0
sql-make $*|db-register
