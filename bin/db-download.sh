#!/bin/bash
# Required packages: wget
# Required scripts: func.temp db-exec
# Required tables: gdocs gsheet
# Desctiption: get db from gdocs and split into db-files
#  split downloaded-db files into db files in the cfg directorys that are categoryzed by project
#  Downloaded-DB format: (%proj),!id,(!another key),field1,field2...
#  Config Dir: ~/cfg.(project)/db
#  Ignore files that don't have (%proj) line
. func.temp
split_sheet(){
    sheet=$1
    # Index line
    egrep -h "^%" $dlfile | cut -d, -f2- > $dbfile
    [ -s $dbfile ] || { _alert "No index line in $sheet"; return 1;}
    file="db-$sheet.csv"
    _overwrite $dbfile ~/utils/db/$file && echo "Update $file"
    # Contents
    for d in ~/cfg.*;do
        sfx=${d#*.}
        egrep -h "^$sfx," $dlfile|cut -d, -f2-|sort > $dbfile
        if [ -s $dbfile ] ;then
            file="db-$sheet-$sfx.csv"
            _overwrite $dbfile $d/db/$file && echo "Update $file"
        fi
    done
}

_usage "[db]"
_temp dlfile dbfile
site="https://docs.google.com/spreadsheets/d/"
key=$(db-exec "select key from gdocs where id == '$1';")
while read line;do
    read sheet gid <<< "${line//|/ }"
    echo $C3"Retrieving $sheet"$C0
    url="$site$key/export?format=csv&id=$key&gid=$gid"
    wget -q --progress=dot -O $dlfile "$url" && split_sheet $sheet
done < <(db-exec "select id,gid from gsheet where gdocs = '$1';")
db-update
for d in ~/cfg.*;do
    cd $d
    file-clean
    git commit -a -m "expand gsheet and update db"
done
