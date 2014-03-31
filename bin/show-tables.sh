#!/bin/bash
# Required packages: coreutils(basename)
# Required scripts: rc.app
# Desctiption: pick up the table names from file name(db-*.csv)
#   if option '-i', show independent tables in db-*.csv
. rc.app
tblcore(){
    local r=${1#*-}
    echo ${r%%[-.]*}
}

# Options
opt-i(){
    _temp fields
    grep -h "^!" db-*.csv|tr ',' '\n'|grep -v '^!'|sort -u > $fields
    for i in db-*.csv;do
        table=$(tblcore $i)
        grep  -q "$table" $fields || echo $table
    done|sort -u|tr "\n" " ";echo
    exit
}

cd ~/db
_usage "(-i:independent tables) [table]"
code=1
for i;do
    if [ -s "$i" ]; then
        tblcore $i
    elif [ -s db-$i.csv ]; then
        echo $i
        code=0
    fi
done
exit $code