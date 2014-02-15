#!/bin/bash
# -r means pick the original one (first stashed)
# otherwise pick last one


case "$1" in
    -l)
        echo "select distinct name from content;"|db-files
        exit
        ;;
    -r)
        shift;sel="min";;
    *) sel="max";;
esac
[ "$1" ] || . set.usage "(-r:revert,-l:list) [file] (host)"
name="$1"
if [ -s "$name" ] ; then
    file-stash $name
    cfid=$(md5sum $name|head -c10)
    uniq=" and list.fid != '$cfid'"
fi
nstr="content.name=='$name'"
host=${2:-$(hostname)}
hstr="list.host=='$host'"
dist=$(info-dist)
dstr="list.dist=='$dist'"
sub_date="select $sel(date) from content,list where content.id == list.fid and $nstr and $hstr and $dstr $uniq"
sub_fid="select id from content where date == ($sub_date)"
fid=$(echo "$sub_fid;"|db-files)
if [ "$fid" ] ; then
    echo "select base64 from content where id == '$fid';"|db-files|base64 -d > $name
    echo "Switch to last file"
else
    echo "No such id stored for $host"
    exit 1
fi