#!/bin/bash
# Required scripts: file-clean
# Description: make links to the specific dirs categorized by file type 
# Desctiption: Files in current dir will be classified into 'bin','db' ..
# "Usage: ${0##*/} [DIR..] | [SRC..]"
cd ~/bin
. setup-bin
while read file dst;do
    src=${file%:*}
    mklink $(readlink $src) $dst
done < <(egrep "^#link(\($DIST\)|) " *)
showlink