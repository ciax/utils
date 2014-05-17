#!/bin/bash
# Required scripts: func.getpar
# Desctiption: pick up the table names from file name(db-*.csv)
. func.getpar
tblcore(){
    local r=${1#*-}
    echo ${r%%[-.]*}
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
