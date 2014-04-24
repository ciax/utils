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
    tsh=~/.trash
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
    echo -n "$sep${PWD#*$top}"
    nouse \#* *~ .*~ *.orig
    nolink * .*
}
top="$PWD/"
echo -n $C3"File Cleaning ("
for i in ${*:-.};do
    (cd $i && _subdirs clrdir)
done
echo ")"$C0