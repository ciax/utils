#!/bin/bash
# Description: make sqlite3 database from csv file
# Required packages: coreutils(grep,tr,cut,tee)
# Required scripts: rc.app, sql-schema, sql-insert
. rc.app
_usage "[tables]"
_temp sch
echo "begin;"
sql-schema $*|tee $sch
for tbl in $(grep '^drop' $sch|tr -d ';'|cut -d' ' -f5);do
    sql-insert $tbl
done
echo "commit;"
