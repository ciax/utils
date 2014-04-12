#!/bin/bash
#alias recall
# Required commands: hostname,zcat
# Required scripts: func.getpar, info-dist, bkup-stash, bkup-exec
# Description: recall backed up file
#  -f means pick the original one (first stashed)
#  otherwise pick last one
. func.getpar
write(){
    mv $content $file
    read mode date < <(bkup-exec "select mode||' '||date from content where id == '$fid';")
    chmod $mode $file
    touch -d "@$date" $file
}
opt-w(){ write='write'; } #write
_usage "[file] (count)"
file="$1"
if [ -s "$file" ] ; then
    cfid=$(bkup-stash $file)
    uniq=" and fid != '$cfid'"
fi
limit="name=='$file' and host=='$(hostname)' and dist=='$(info-dist)'"
sub_fid="select fid from list where $limit $uniq"
sub_date="select max(date) from content where id in ($sub_fid)"
date=$(bkup-exec "$sub_date;")
sub_id="select id from content where date == '$date'"
fid=$(bkup-exec "$sub_id;")
if [ "$fid" ] ; then
    . func.temp
    _temp content
    bkup-exec "select base64 from content where id == '$fid';"|base64 -d|zcat > $content
    $write
    sub_fid="select fid from list where $limit"
    total=$(bkup-exec "select count(id) from content where id in ($sub_fid);")
    rank=$(bkup-exec "select count(id) from content where id in ($sub_fid) and date > '$date';")
    echo "Recall OK($rank/$total)"
else
    _abort "No such file stored"
fi
