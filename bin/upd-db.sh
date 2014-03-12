#!/bin/bash
# Description: update databases
# Required sckipts: sql-make, db-register
# Required tables: mac,ssl,ssh
set - $(show-tables -i|tr '\n' ' ')
echo $C3"Database update for $*"$C0
sql-make $*|db-register
