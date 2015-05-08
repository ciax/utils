#!/bin/bash
PATH=$HOME/bin:$PATH
. ~/utils/bin/func.msg.sh
. ~/utils/bin/func.link.sh
. ~/utils/bin/func.dirs.sh
_warn "File Registering (~/bin)"
for i in ~/utils/bin $*;do
    pushd $i >/dev/null
    _subdirs _binreg
    popd >/dev/null
done
_showlink
