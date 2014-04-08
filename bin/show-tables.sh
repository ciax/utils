#!/bin/bash
# Required scripts: func.getpar,func.temp
# Desctiption: pick up the table names from file name(db-*.csv)
#   if option '-e', show tables of the dependency ends in db-*.csv
. func.getpar
tblcore(){
    local r=${1#*-}
    echo ${r%%[-.]*}
}

# Options
opt-e(){ #end tables
    cd ~/utils/db
    . func.temp
    _temp fields
    grep -h "^!" db-*.csv|tr ',' '\n'|grep -v '^!'|sort -u > $fields
    for i in db-*.csv;do
        table=$(tblcore $i)
        grep  -q "$table" $fields || echo $table
    done|sort -u|tr "\n" " ";echo
    exit
}

_usage "[table]"
err=1
for i;do
    if [ -s "$i" ]; then
        tblcore $i
        err=0
    else
        for j in db-$i*.csv;do
            echo $i
            err=0
            break
        done
    fi
done
exit $err
