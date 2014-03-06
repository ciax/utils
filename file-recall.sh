#!/bin/bash
# -r means pick the original one (first stashed)
# otherwise pick last one
case "$1" in
    -l)
        db-files <<< "select distinct name from content;"
        exit
        ;;
    -f)
        shift;sel="min";;
    *) sel="max";;
esac
. func.usage "(-f:first,-l:list) [file] (host)" $1
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
fid=$(db-files <<< "$sub_fid;")
if [ "$fid" ] ; then
    db-files <<< "select base64 from content where id == '$fid';"|base64 -d > $name
    echo "Recall OK"
else
    echo1 "No such id stored for $host"
    exit 1
fi
