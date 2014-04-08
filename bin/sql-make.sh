#!/bin/bash
# Required scripts: func.getpar,func.temp, sql-schema, sql-insert
# Description: make sqlite3 database from csv file
. func.getpar
_usage "[tables]"
. func.temp
_temp sch
echo "begin;"
sql-schema $*|tee $sch
for tbl in $(grep '^drop' $sch|tr -d ';'|cut -d' ' -f5);do
    sql-insert $tbl
done
echo "commit;"
