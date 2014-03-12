#!/bin/bash
# Description: split db files into each cfg directory which is categoryzed by group
# Required packages: coreutils
# Required scripts: func.usage, func.temp, show-tables
. func.usage "[dbfiles]" $1
. func.temp dbfile
for src;do
    base=db-$(show-tables $src)||continue
    for d in ~/cfg.*;do
        sfx=${d#*.}
        grep -h ",$sfx," $src > $dbfile
        if [ -s $dbfile ] ;then
            overwrite $dbfile $d/db/$base-$sfx.csv && echo "Update $base-$sfx.csv"
        fi
    done
    egrep -e "^!" $src > $dbfile
    egrep -q ",group," $dbfile || egrep -v -e "^#" $src > $dbfile
    overwrite $dbfile ~/utils/db/$base.csv && echo "Update $base.csv"
done
