#!/bin/bash
# Description: Dir setup and File registration
for dir in bin .var .trash; do
    [ -d "$HOME/$dir" ] || mkdir -p "$HOME/$dir"
done
PATH=$HOME/bin:$PATH
. ~/utils/bin/func.msg.sh
. ~/utils/bin/func.link.sh
. ~/utils/bin/func.dirs.sh
_warn "File Registering (~/bin)"
for i in ~/utils $*;do
    pushd $i >/dev/null
    _subdirs _binreg
    popd >/dev/null
done
_showlink
