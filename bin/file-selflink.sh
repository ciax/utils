#!/bin/bash
# Required scripts: func.link func.temp
# Description: make links to the specific dirs categorized by file type 
# Desctiption: Files in cfg.*/ utils/ and current dirs will be classified into 'bin','db' ..
# "Usage: ${0##*/} [DIR..] | [SRC..]"
#alias slink
. func.link
. func.temp
_warn "File Self Registering"
_temp linklist
egrep -Hr "^[#;]link(\(($DIST|$HOSTNAME)\)|) " ~/{cfg.*,utils} $*|sort -u > $linklist
while read spath dpath;do
    set - $(_abspath ${spath%:*})
    sdir=$1;src=$2
    dst=$(basename $dpath)
    if [[ $src =~ \.(sh|pl|py|rb|awk|exp|js)$ ]]; then
        ddir=~/bin
    else
        ddir=$(eval "cd $(dirname $dpath)";pwd -P);
    fi
    _mklink $sdir/$src $ddir ${dst:-$src}
done < $linklist
_showlink
