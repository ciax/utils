#!/bin/bash
# Required packages: wget
# Required scripts: rc.app db-exec
# Required tables: gdocs,gsheet
# Desctiption: get db from gdocs
. rc.app
_usage "[db]"
site="https://docs.google.com/spreadsheets/d/"
id=$(db-exec "select key from gdocs where id == '$1';")
while read line;do
    read sheet gid <<< "${line//|/ }"
    url="$site$id/export?format=csv&id=$id&gid=$gid"
    wget -O db-$sheet.csv "$url"
done < <(db-exec "select id,gid from gsheet where gdocs = '$1';")



