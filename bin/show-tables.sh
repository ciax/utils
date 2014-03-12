#!/bin/bash
# Desctiption: pick up the table names from file name(db-*.csv)
#   if option '-i', show independent tables in db-*.csv
# Required packages: coreutils(basename)
# Required scripts: func.usage, func.temp
tblcore(){
    local r=${1#*-}
    echo ${r%%[-.]*}
}
. func.usage "(-i:independent tables) [table]" $1
if [ "$1" = "-i" ] ; then
    . func.temp fields
    grep -h "^!" db-*.csv|tr ',' '\n'|grep -v '^!'|sort -u > $fields
    for i in db-*.csv;do
        table=$(tblcore $i)
        grep  -q "$table" $fields || echo $table
    done|sort -u
else
    for i;do
        if [ -s "$i" ]; then
            tblcore $i
        elif [ -s db-$i.csv ]; then
            echo $i
        fi
    done
fi