#!/bin/bash
# Required packages: coreutils
# Required scripts: rc.app, show-tables
# Description: split export-db files into db files in the cfg directorys that are categoryzed by project
#  Export-DB format: (%proj),!id,(!another key),field1,field2...
#  Config Dir: ~/cfg.(project)/db
. rc.app
_usage "[dbfiles]"
_temp dbfile
for src;do
    tbl=$(show-tables $src)||continue
    for d in ~/cfg.*;do
        sfx=${d#*.}
        egrep -h "^$sfx," $src|cut -d, -f2- > $dbfile
        if [ -s $dbfile ] ;then
            _overwrite $dbfile $d/db/db-$tbl-$sfx.csv && echo "Update db-$tbl-$sfx.csv"
        fi
    done
    egrep -h "^%" $src | cut -d, -f2- > $dbfile
    _overwrite $dbfile ~/utils/db/db-$tbl.csv && echo "Update db-$tbl.csv"
done
file-register
