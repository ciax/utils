#!/bin/bash
. set.color
dbs="mac ssl ssh"
sql-make $dbs|db-register
echo "${C3}Database update for $dbs$C0"
