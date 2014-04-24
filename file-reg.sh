#!/bin/bash
# Required scripts: func.link,func.dirs,file-clean
# Description: make links to the specific dirs categorized by file type 
# Desctiption: Files in current dir will be classified into 'bin','db' ..
# "Usage: ${0##*/} [DIR..] | [SRC..]"
. func.link
. func.dirs
echo $C3"File Registering"$C0
_subdirs _binreg
cd ~/bin
while read file dst;do
    src=${file%:*}
    _mklink $(readlink $src) $dst
done < <(egrep "^#link(\($DIST\)|) " *)
_showlink
file-clean