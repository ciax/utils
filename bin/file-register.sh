#!/bin/bash
# Required scripts: func.link file-clean file-selflink
# Description: Script file registration to ~/bin
. file-clean ~/bin
. func.link
_warn "File Registering ($HOME/bin)"
for i in ~/utils/bin $*;do
    if [ -d "$i" ]; then
        pushd $i >/dev/null
        _subdirs _setup
        popd >/dev/null
    else
        _linkbin "$i"
    fi
done
_showlink
file-selflink
