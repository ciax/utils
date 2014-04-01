#!/bin/bash
# Required packages: wget
# Required scripts: rc.app, db-exec, file-register
# Required tables: gdocs,gsheet
# Desctiption: get db from gdocs and split into db-files
#  split downloaded-db files into db files in the cfg directorys that are categoryzed by project
#  Downloaded-DB format: (%proj),!id,(!another key),field1,field2...
#  Config Dir: ~/cfg.(project)/db
#  Ignore files that don't have (%proj) line
. rc.app

split_sheet(){
    sheet=$1
    # Index line
    egrep -h "^%" $dlfile | cut -d, -f2- > $dbfile
    [ -s $dbfile ] || return 1
    _overwrite $dbfile ~/utils/db/db-$sheet.csv && echo "Update db-$sheet.csv"
    # Contents
    for d in ~/cfg.*;do
        sfx=${d#*.}
        egrep -h "^$sfx," $dlfile|cut -d, -f2- > $dbfile
        if [ -s $dbfile ] ;then
            _overwrite $dbfile $d/db/db-$sheet-$sfx.csv && echo "Update db-$sheet-$sfx.csv"
        fi
    done
}

_usage "[db]"
_temp dlfile dbfile
site="https://docs.google.com/spreadsheets/d/"
key=$(db-exec "select key from gdocs where id == '$1';")
while read line;do
    read sheet gid <<< "${line//|/ }"
    url="$site$key/export?format=csv&id=$key&gid=$gid"
    wget -O $dlfile "$url" && split_sheet $sheet
done < <(db-exec "select id,gid from gsheet where gdocs = '$1';")
file-register
