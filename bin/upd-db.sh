#!/bin/bash
dbs="mac ssl ssh"
echo "${C3}Database update for $dbs$C0"
sql-make $dbs|db-register
