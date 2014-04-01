#!/bin/bash
#alias stash
# Required packages: coreutils(md5,base64),gzip
# Required scripts: src.app,bkup-exec
# Required table: content,list
#   content: fid(md5),name,mode,date,base64(gziped)
#   list: id(date),host,dist,owner,dir,fid
. src.app
_usage "[file]"
[ -s "$1" ] || _abort "No such file"
host=$(hostname)
fid=$(md5sum $1|head -c10)
dir=$(dirname `realpath $1`)
base64=$(gzip -c $1|base64 -w0)
dist=$(info-dist)
stat -c "%n %a %Y %U" $1 | {
    read name mode date owner
    bkup-exec <<EOF
insert or ignore into content values('$fid','$mode','$date','$base64');
insert or ignore into list values('$fid','$host','$dist','$owner','$name','$dir');
EOF
    echo "File stashed"
}
