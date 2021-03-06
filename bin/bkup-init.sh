#!/bin/bash
# Required scripts: bkup-exec
# Required tables: content list
#   content: fid(md5),name,mode,date,base64(gziped)
#   list: id(date),host,dist,owner,dir,fid
# option (-r) : reset data
. func.msg
[ -s ~/.var/log/bkup.sq3 -a "$1" != -r ] && exit
bkup-exec <<EOF
drop table if exists content;
drop table if exists list;
create table content (id primary key,mode,date,base64);
create table list (fid,host,dist,owner,name,dir,primary key(fid,host,dist));
EOF
_comp "Bkup DB initialized"
