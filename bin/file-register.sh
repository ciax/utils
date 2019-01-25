#!/bin/bash
# Required scripts: func.link file-clean link-self
# Description: Script file registration to ~/bin
. file-clean ~/bin
. func.link
_warn "File Registering to $HOME/bin"
sbin=~/utils/sbin
bin=~/utils/bin
ls -al ~/bin|grep -q $sbin && bin=$sbin\ $bin
for i in ${*:-$bin};do
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
link-self
