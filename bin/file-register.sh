#!/bin/bash
# Required scripts: func.link file-clean file-selflink
# Description: Script file registration to ~/bin
. file-clean ~/bin
. func.link
_warn "File Registering ($HOME/bin)"
for i in ~/utils/bin $*;do
    pushd $i >/dev/null
    _subdirs _binreg
    popd >/dev/null
done
_showlink
. file-selflink
