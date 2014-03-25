#!/bin/bash
#CONTENT: fid(md5),name,mode,date,base64
#LIST: id(date),host,dist,owner,dir,fid
. rc.app
_usage "(-i:init db) [file]" $1
if [ "$1" = -i ] ; then
    shift
    bkup-sqlite <<EOF
drop table if exists content;
drop table if exists list;
create table content (id primary key,name,mode,date,base64);
create table list (fid,host,dist,owner,dir,primary key(fid,host,dist));
EOF
fi
[ -s "$1" ] ||  { echo1 "No such file"; exit 1; }
host=$(hostname)
fid=$(md5sum $1|head -c10)
dir=$(dirname `realpath $1`)
base64=$(base64 -w0 $1)
dist=$(info-dist)
stat -c "%n %a %Y %U" $1 | {
    read name mode date owner
    bkup-sqlite <<EOF
insert or ignore into content values('$fid','$name','$mode','$date','$base64');
insert or ignore into list values('$fid','$host','$dist','$owner','$dir');
EOF
    echo "File stashed"
}
