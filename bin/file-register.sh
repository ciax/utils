#!/bin/bash
# Required scripts: func.link file-clean file-link
# Description: Script file registration to ~/bin
. file-clean ~/bin
. func.link
_warn "File Registering to $HOME/bin"
sbin=~/utils/sbin
def=$(
    for i in $0 ~/bin/*; do
        dirname $(realpath $i)
    done | sort -u
)

for i in ${*:-$def};do
    if [ -d "$i" ]; then
        pushd $i >/dev/null
        _warn "  Registering ($PWD)"
        _subdirs _setup_link
        popd >/dev/null
    else
        _linkbin "$i"
    fi
done
_showlink
file-link
