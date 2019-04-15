#!/bin/bash
# Required scripts: func.getpar func.dirs
# Description: File clean up (remove backup,unlinked files)
#alias clr
. func.getpar
. func.dirs
opt-r(){
    clrcmd='_subdirs'
}
_chkdir(){
    [ -h "$1" ] && return 1
    [ -d "$1" ] && return
    [ -e "$1" ] && { _alert "Not a directory $1";return 1; }
    mkdir "$1"
}
_nouse(){
    local tsh=~/.trash
    mkdir -p $tsh || _abort "Can't make $tsh"
    [ "$1" ] || return
    mv -fb "$@" $tsh
    ls -aF --color
}
_nolink(){
    for i ; do
        [ -L "$i" -a ! -e "$i" ] || continue
        rm -f "$i"
        _alert "[${i##*/}] is not linked"
    done
}
_clrdir(){
    if [[ $PWD == */.trash ]] ; then
        rm -rf *
    else
        _nouse \#* *~ .*~ *.orig
        _nolink * .*
    fi
}
clrcmd=_do_here
_exe_opt
[ $PWD = ~/bin ] || def=~bin
for i in ${*:-.} $def;do
    if [[ $PWD =~ $HOME ]] ; then
        pushd $i >/dev/null
        $clrcmd _clrdir
        popd >/dev/null
    else
        _warn "Under another user's dir"
    fi
done
[ "$_dirlist" ] && {
    _title "File Cleaning"
    _msg "  ($_dirlist)"
}
