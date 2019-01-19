#!/bin/bash
# Required packages: wget
# Required scripts: func.getpar db-exec
# Required tables: gdocs gsheet
# Description: get db from gdocs and split into db-files
#  split downloaded-db files into db files in the cfg directorys that are categoryzed by project
#  Downloaded-DB format(tsv): (%proj) !id (!another key) field1 field2...
#  Config Dir: ~/cfg.(project)/db
#  Ignore files that don't have (%proj) line
. func.getpar
split_sheet(){
    sheet=$1
    # Index line
    egrep -h "^%" $dlfile | cut -f2- > $dbfile
    [ -s $dbfile ] || { _alert "No index line in $sheet"; return 1;}
    file="db-$sheet.tsv"
    _overwrite ~/utils/db/$file < $dbfile && _msg "Update $file"
    # Contents
    for d in ~/cfg.*;do
        sfx=${d#*.}
        egrep -h "^$sfx" $dlfile|cut -f2-|sort > $dbfile
        if [ -s $dbfile ] ;then
            file="db-$sheet-$sfx.tsv"
            _overwrite $d/db/$file < $dbfile && _msg "Update $file"
        fi
    done
}

_usage "[db]"
_temp dlfile dbfile
site="https://docs.google.com/spreadsheets/d/"
key=$(db-exec "select key from gdocs where id == '$1';")
[ "$key" ] || _abort "No gdocs key in db"
dldir=~/.var/cache/download
mkdir -p $dldir
while read line;do
    read sheet gid <<< "${line//|/ }"
    url="$site$key/export?format=tsv&id=$key&gid=$gid"
    _warn "Retriving $C1$sheet$C0($url)"
    wget -q --progress=dot -O $dlfile "$url" || continue
    grep "'" $dlfile && { _alert "Field includes ' -> reject"; continue; }
    nkf -d --in-place $dlfile
    split_sheet $sheet
    cp $dlfile $dldir/$sheet.tsv
done < <(db-exec "select id,gid from gsheet where gdocs = '$1';")
db-update
for d in ~/cfg.*/db ~/utils/db;do
    cd $d
    file-clean
    git commit *.tsv -m "expand gsheet and update db"
    git push
done
