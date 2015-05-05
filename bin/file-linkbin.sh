#!/bin/bash
# Required scripts: func.link func.dirs
# Description: make links to the specific dirs categorized by file type 
# Desctiption: Files in current dir will be classified into 'bin','db' ..
# "Usage: ${0##*/} [DIR..] | [SRC..]"
selflink(){
    egrep -H "^[#;]link(\(.*,?$DIST,?.*\)|) " ~/bin/* |\
    while read file dst;do
        src=${file%:*}
        _mklink $(readlink $src) ~/bin $dst
    done
}
. func.link
. func.dirs
echo $C3"File Registering (~/bin)"$C0
for i in ~/utils $*;do
    pushd $i >/dev/null
    _subdirs _binreg
    popd >/dev/null
done
selflink
_showlink
