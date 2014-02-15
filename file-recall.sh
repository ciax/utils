#!/bin/bash
[ "$1" ] ||  . set.usage "[file] (host)"
name="$1"
host=${2:-$(hostname)}
cfid=$(md5sum $1|head -c10)
dist=$(info-dist)
file-stash $name
echo "select * from list;"|db-files
maxid="select max(id) from list where name == '$name' and host == '$host' and dist == '$dist' and fid != '$cfid'"
echo "$maxid;"|db-files
newest="select fid from list where id == ($maxid)"
fid=$(echo "$newest;"|db-files)
[ "$fid" ] || { echo "No such id"; exit; }
echo "select base64 from content where id == '$fid';"|db-files|base64 -d > $name
