#!/bin/bash
#alias clr
# Description: File clean up (remove backup,unlinked files)

shopt -s nullglob
chkdir(){
    [ -h "$1" ] && return 1
    [ -d "$1" ] && return
    [ -e "$1" ] && { echo $C1"Not a directory $1"$C0;return 1; }
    mkdir "$1"
}
nouse(){
    tsh=~/.trash
    [ "$1" ] || return
    [ -d $tsh ] || mkdir $tsh || { echo "Can't make $tsh"; exit 1; }
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
    for i;do
        chkdir "${i%/}" || continue
        pushd "$i" >/dev/null
        nouse \#* *~ .*~ *.orig
        nolink * .*
        clrdir */
        popd >/dev/null
    done
}
echo $C3"File Cleaning"$C0
[ "$1" ] || set - .
clrdir $*
