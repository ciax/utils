#!/bin/bash
# Required commands: grep,tr,cut,tee
# Required scripts: func.app, sql-schema, sql-insert
# Description: make sqlite3 database from csv file
. func.app
_usage "[tables]"
_temp sch
echo "begin;"
sql-schema $*|tee $sch
for tbl in $(grep '^drop' $sch|tr -d ';'|cut -d' ' -f5);do
    sql-insert $tbl
done
echo "commit;"
