#!/bin/bash
# Required scripts: func.link func.dirs
# Description: make links to the specific dirs categorized by file type 
# Desctiption: Files in cfg.*/ utils/ and current dirs will be classified into 'bin','db' ..
# "Usage: ${0##*/} [DIR..] | [SRC..]"
. func.link
. func.temp
echo $C3"File Self Registering"$C0
_temp linklist
egrep -Hr "^[#;]link(\(.*,?$DIST,?.*\)|) " ~/{cfg.*,utils} $*|sort -u > $linklist

while read spath dpath;do
    set - $(_abspath ${spath%:*})
    sdir=$1;src=$2
    set - $(_abspath $dpath)
    ddir=$1;dst=$2
    [[ $src =~ \.(sh|pl|py|rb|awk|exp|js)$ ]] && ddir=~/bin
    _mklink $sdir/$src $ddir ${dst:-$src}
done < $linklist
_showlink
