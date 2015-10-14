#!/bin/bash
# Required scripts: func.msg func.dirs
# Description: File clean up (remove backup,unlinked files)
#alias clr
. func.dirs
_chkdir(){
    [ -h "$1" ] && return 1
    [ -d "$1" ] && return
    [ -e "$1" ] && { _alert "Not a directory $1";return 1; }
    mkdir "$1"
}
_nouse(){
    local tsh=~/.trash
    [ -d $tsh ] || mkdir $tsh || _abort "Can't make $tsh"
    [ "$1" ] || return
    sudo mv -fb "$@" $tsh
    ls -aF --color
}
_nolink(){
    for i ; do
        [ -L "$i" -a ! -e "$i" ] || continue
        rm "$i"
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
for i in ${*:-.};do
    pushd $i >/dev/null
    _subdirs _clrdir
    popd >/dev/null
done
_warn "File Cleaning ($_dirlist)"
