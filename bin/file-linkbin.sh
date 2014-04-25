#!/bin/bash
# Required scripts: func.link,func.dirs,file-clean
# Description: make links to the specific dirs categorized by file type 
# Desctiption: Files in current dir will be classified into 'bin','db' ..
# "Usage: ${0##*/} [DIR..] | [SRC..]"
selflink(){
    cd ~/bin
    while read file dst;do
        src=${file%:*}
        _mklink $(readlink $src) $dst
    done < <(egrep -H "^[#;]link(\($DIST\)|) " *)
}
. func.link
. func.dirs
echo $C3"File Registering (~/bin)"$C0
for i in ${*:-.};do
    (cd $i;_subdirs _binreg)
done
selflink
_showlink
file-clean ~/bin