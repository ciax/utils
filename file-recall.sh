#!/bin/bash
# -r means pick the original one (first stashed)
# otherwise pick last one
case "$1" in
    -l)
        echo "select distinct name from content;"|db-files
        exit
        ;;
    -f)
        shift;sel="min";;
    *) sel="max";;
esac
. set.usage "(-f:first,-l:list) [file] (host)" $1
name="$1"
if [ -s "$name" ] ; then
    file-stash $name >/dev/null
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
    echo "Recall OK"
else
    . set.error "No such id stored for $host"
fi