#!/bin/bash
# Required scripts: bkup-exec
# Required table: content,list
#   content: fid(md5),name,mode,date,base64(gziped)
#   list: id(date),host,dist,owner,dir,fid
bkup-exec <<EOF
drop table if exists content;
drop table if exists list;
create table content (id primary key,mode,date,base64);
create table list (fid,host,dist,owner,name,dir,primary key(fid,host,dist));
EOF
