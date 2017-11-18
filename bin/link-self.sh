#!/bin/bash
# Required scripts: func.link func.temp
# Description: make links to the specific dirs categorized by file type 
# Desctiption: Files in cfg.*/ utils/ and current dirs will be classified into 'bin','db' ..
# (Ubuntu need to install realpath)
# "Usage: ${0##*/} [DIR..] | [SRC..]"
#alias slink
. func.link
. func.temp
_warn "File Self Registering"
_temp linklist
egrep -Hr "^[#;]link(\((.+,)*($DIST|$HOSTNAME)(,.+)*\)|) " ~/{cfg.*,utils} $*|sort -u > $linklist
while read spath dst;do
    src=${spath%:*}
    if [[ $src =~ \.(sh|pl|py|rb|awk|exp|js)$ ]]; then
        dst=~/bin/$(basename $dst)
    fi
    _mklink $src $dst
done < $linklist
_showlink
