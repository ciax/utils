#!/bin/bash
#alias stash
# Required packages: gzip
# Required scripts: func.getpar info-dist bkup-exec
# Required table: content list
#   content: fid(md5),name,mode,date,base64(gziped)
#   list: id(date),host,dist,owner,dir,fid
. func.getpar
_usage "[file]"
[ -s "$1" ] || _abort "No such file"
bkup-init
host=$(hostname)
fid=$(md5sum $1|head -c10)
dir=$(cd $(dirname $1);pwd -P)
name=$(basename $1)
base64=$(gzip -c $1|base64 -w0)
dist=$(info-dist)
stat -c "%a %Y %U" $1 | {
    read mode date owner
    bkup-exec <<EOF
insert or ignore into content values('$fid','$mode','$date','$base64');
insert or ignore into list values('$fid','$host','$dist','$owner','$name','$dir');
EOF
    echo "$fid"
}
