#!/bin/bash
[ "$1" ] ||  . set.usage "[file] (host)"
name="$1"
host=${2:-$(hostname)}
dist=$(info-dist)
if [ -s "$name" ] ; then
    file-stash $name
    cfid=$(md5sum $1|head -c10)
    opt=" and fid != '$cfid'"
fi
maxid="select max(id) from list where name == '$name' and host == '$host' and dist == '$dist' $opt"
newest="select fid from list where id == ($maxid)"
fid=$(echo "$newest;"|db-files)
[ "$fid" ] || { echo "No such id"; exit; }
echo "select base64 from content where id == '$fid';"|db-files|base64 -d > $name
