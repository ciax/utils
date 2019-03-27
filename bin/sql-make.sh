#!/bin/bash
# Required scripts: func.getpar sql-schema sql-insert
# Description: make sqlite3 database from tsv file
. func.getpar
_usage "[tables]"
_temp sch
echo "begin;"
cd ~/utils/db
sql-schema $*|tee $sch
for tbl in $(grep '^drop' $sch|cut -d' ' -f5)
do
    for dir in ~/cfg.*/db
    do
        cd $dir
        sql-insert ${tbl%;}
    done
done
echo "commit;"
