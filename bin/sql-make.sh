#!/bin/bash
# Description: make sqlite3 database from csv file
# Required packages: coreutils(grep,tr,cut,tee)
# Required scripts: func.usage, func.temp, sql-schema, sql-insert
. func.usage "[tables]" $1
. func.temp sch
echo "begin;"
sql-schema $*|tee $sch
for tbl in $(grep '^drop' $sch|tr -d ';'|cut -d' ' -f5);do
    sql-insert $tbl
done
echo "commit;"
