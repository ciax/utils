#!/bin/bash
# Description: update databases
# Required sckipts: sql-make, db-register
# Required tables: mac,ssl,ssh
dbs="mac ssl ssh"
echo $C3"Database update for $dbs"$C0
sql-make $dbs|db-register
