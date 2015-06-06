#!/bin/bash
# Required scripts: func.getpar
# Desctiption: show tables of the dependency ends in db-*.tsv
. func.getpar
tblcore(){
    local r=${1#*-}
    echo ${r%%[-.]*}
}

cd ~/utils/db
_temp fields
grep -h "^!" db-*.tsv|tr '\t' '\n'|grep -v '^!'|sort -u > $fields
for i in db-*.tsv;do
    table=$(tblcore $i)
    grep  -q "$table" $fields || echo $table
done|sort -u|tr "\n" " ";echo
