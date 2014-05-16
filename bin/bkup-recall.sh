#!/bin/bash
#alias recall
# Required scripts: func.getpar info-dist bkup-stash bkup-exec
# Description: recall latest backed up file
. func.getpar
write(){
    mv $content $file
    mode=$(bkup-exec "select mode from content where id == '$fid';")
    chmod $mode $file
    touch -d "@$date" $file
}
opt-w(){ func='write'; } #overwrite
_usage "[file]"
file="$1"
if [ -s "$file" ] ; then
    cfid=$(bkup-stash $file)
    uniq=" and fid != '$cfid'"
fi
#get fid
limit="name=='$file' and host=='$(hostname)' and dist=='$(info-dist)'"
sub_fid="select fid from list where $limit $uniq"
sub_date="select max(date) from content where id in ($sub_fid)"
date=$(bkup-exec "$sub_date;")
sub_id="select id from content where date == '$date'"
fid=$(bkup-exec "$sub_id;")
if [ "$fid" ] ; then
    . func.temp
    _temp content
    bkup-exec "select base64 from content where id == '$fid';"|base64 -d|zcat|tee $content
    $func
    sub_fid="select fid from list where $limit"
    total=$(bkup-exec "select count(id) from content where id in ($sub_fid);")
    rank=$(bkup-exec "select count(id) from content where id in ($sub_fid) and date > '$date';")
    date=$(bkup-exec "select date from content where id == '$fid';")
    echo $C3"Recall OK($rank/$total) [$(date --date=@$date)]"$C0
else
    _abort "No such file stored"
fi
