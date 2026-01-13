#!/bin/bash
# Required scripts: func.link file-clean file-link
# Description: Script file symlink to ~/bin
. file-clean
. func.link
_title "File SymLink to ~/bin"
for i in ${*:-.};do
    if [ -d "$i" ]; then
        pushd $i >/dev/null
        _msg "  Registering ($PWD)"
        _subdirs _setup_link
        popd >/dev/null
    else
        _linkbin "$i"
    fi
done
_showlink
file-link
