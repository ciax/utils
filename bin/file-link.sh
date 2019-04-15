#!/bin/bash
# Required scripts: func.link func.file
# Description: make links of another name to the specific dirs categorized by file type
# Description: Files in ~/bin and current dirs will be classified into 'bin','db' ..
# (Ubuntu need to install realpath)
# "Usage: ${0##*/} [DIR..] | [SRC..]"
#alias flink
. func.link
. func.file
_title "File Self Registering"
_temp linklist
_msg '  grep cfg.*, utils for link'
egrep -H "^[#;]link(\((.+,)*($DIST|$HOSTNAME)(,.+)*\)|) " ~/bin/* $*|sort -u > $linklist
while read spath dst;do
    echo -n '.'
    src=$(realpath ${spath%:*})
    if [[ $src =~ \.(sh|pl|py|rb|awk|exp|js)$ ]]; then
        dst=~/bin/$(basename $dst)
    fi
    _mklink $src $dst
done < $linklist
echo
_showlink
