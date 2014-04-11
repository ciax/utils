#!/bin/bash
#alias recall
# Required commands: hostname,zcat
# Required scripts: func.getpar, info-dist, bkup-stash, bkup-exec
# Description: recall backed up file
#  -f means pick the original one (first stashed)
#  otherwise pick last one
. func.getpar
sel="max"
opt-f(){ sel="min"; } #first
_usage "[file] (host)"
name="$1"
if [ -s "$name" ] ; then
    bkup-stash $name >/dev/null
    cfid=$(md5sum $name|head -c10)
    uniq=" and fid != '$cfid'"
fi
host=${2:-$(hostname)}
limit="name=='$name' and host=='$host' and dist=='$(info-dist)'"
sub_fid="select fid from list where $limit $uniq"
sub_date="select $sel(date) from content where id in ($sub_fid)"
date=$(bkup-exec "$sub_date;")
sub_id="select id from content where date == '$date'"
fid=$(bkup-exec "$sub_id;")
if [ "$fid" ] ; then
    bkup-exec "select base64 from content where id == '$fid';"|base64 -d|zcat > $name
    bkup-exec "select mode,date from content where id == '$fid';" | {
        IFS=,;read mode date
        chmod $mode $name
        touch -d "@$date" $name
    }
    sub_fid="select fid from list where $limit"
    total=$(bkup-exec "select count(id) from content where id in ($sub_fid);")
    rank=$(bkup-exec "select count(id) from content where id in ($sub_fid) and date > '$date';")
    echo "Recall OK($rank/$total)"
else
    _abort "No such id stored for $host"
fi
