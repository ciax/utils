#!/bin/bash
# Required scripts: func.msg func.dirs
# Description: File clean up (remove backup,unlinked files)
#alias clr
. func.dirs
chkdir(){
    [ -h "$1" ] && return 1
    [ -d "$1" ] && return
    [ -e "$1" ] && { _alert "Not a directory $1";return 1; }
    mkdir "$1"
}
nouse(){
    local tsh=~/.trash
    [ -d $tsh ] || mkdir $tsh || _abort "Can't make $tsh"
    [ "$1" ] || return
    sudo mv -fb "$@" $tsh
    ls -aF --color
}
nolink(){
    for i ; do
        [ -L "$i" -a ! -e "$i" ] || continue
        rm "$i"
        _warn "[${i##*/}] is not linked"
    done
}
clrdir(){
    if [[ $PWD == */.trash ]] ; then
        rm -rf *
    else
        nouse \#* *~ .*~ *.orig
        nolink * .*
    fi
}
for i in ${*:-.};do
    pushd $i >/dev/null
    _subdirs clrdir
    popd >/dev/null
done
_warn "File Cleaning ($_dirlist)"
