#!/bin/bash
#alias recall
# -r means pick the original one (first stashed)
# otherwise pick last one
. rc.app
sel="max"
opt-f(){ sel="min"; }
_usage "(-f:first) [file] (host)"
name="$1"
if [ -s "$name" ] ; then
    bkup-stash $name >/dev/null
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
fid=$(bkup-exec <<< "$sub_fid;")
if [ "$fid" ] ; then
    bkup-exec <<< "select base64 from content where id == '$fid';"|base64 -d|zcat > $name
    echo "Recall OK"
else
    _abort "No such id stored for $host"
fi
