#!/bin/bash
#alias recall
# -f means pick the original one (first stashed)
# otherwise pick last one
. rc.app
sel="max"
opt-f(){ sel="min"; }
_usage "(-f:first) [file] (host)"
name="$1"
if [ -s "$name" ] ; then
    bkup-stash $name >/dev/null
    cfid=$(md5sum $name|head -c10)
    uniq=" and fid != '$cfid'"
fi
nstr="name=='$name'"
host=${2:-$(hostname)}
hstr="host=='$host'"
dist=$(info-dist)
dstr="dist=='$dist'"
sub_fid="select fid from list where $nstr and $hstr and $dstr $uniq"
sub_date="select $sel(date) from content where id in ($sub_fid)"
sub_id="select id from content where date == ($sub_date)"
fid=$(bkup-exec "$sub_id;")
if [ "$fid" ] ; then
    bkup-exec "select base64 from content where id == '$fid';"|base64 -d|zcat > $name
    echo "Recall OK"
else
    _abort "No such id stored for $host"
fi
