#!/bin/bash
#alias clr
# Required scripts: func.dirs
# Description: File clean up (remove backup,unlinked files)
. func.dirs
shopt -s nullglob
chkdir(){
    [ -h "$1" ] && return 1
    [ -d "$1" ] && return
    [ -e "$1" ] && { echo $C1"Not a directory $1"$C0;return 1; }
    mkdir "$1"
}
nouse(){
    local tsh=~/.trash
    [ -d $tsh ] || mkdir $tsh || { echo "Can't make $tsh"; exit 1; }
    [ "$1" ] || return
    /bin/mv -fb "$@" $tsh
    /bin/ls -aF --color
}
nolink(){
    for i ; do
        [ -L "$i" -a ! -e "$i" ] || continue
        /bin/rm "$i"
        echo $C3"[${i##*/}] is not linked"$C0
    done
}
clrdir(){
    if [[ $PWD == */.trash ]] ; then
        /bin/rm -rf *
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
echo $C3"File Cleaning ($_dirlist)"$C0
