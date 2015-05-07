#!/bin/bash
# Description: Dir setup and File registration
#alias reg
for dir in bin .var .trash; do
    [ -d "$HOME/$dir" ] || mkdir -p "$HOME/$dir"
done
PATH=$HOME/bin:$PATH
. ~/utils/func.msg.sh
. ~/utils/func.link.sh
. ~/utils/func.dirs.sh
echo $C3"File Registering (~/bin)"$C0
for i in ~/utils $*;do
    pushd $i >/dev/null
    _subdirs _binreg
    popd >/dev/null
done
_showlink
