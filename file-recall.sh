#!/bin/bash
# -r means pick the original one (first stashed)
# otherwise pick last one

sel="max"
[ "$1" = -r ] && { shift;sel="min"; }
[ "$1" ] ||  . set.usage "(-r:revert)[file] (host)"
name="$1"
host=${2:-$(hostname)}
dist=$(info-dist)
if [ -s "$name" ] ; then
    file-stash $name
    cfid=$(md5sum $1|head -c10)
    opt=" and fid != '$cfid'"
fi

selid="select $sel(id) from list where name == '$name' and host == '$host' and dist == '$dist' $opt"
newest="select fid from list where id == ($selid)"
fid=$(echo "$newest;"|db-files)
[ "$fid" ] || { echo "No such id"; exit; }
echo "select base64 from content where id == '$fid';"|db-files|base64 -d > $name
