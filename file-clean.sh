#!/bin/bash
#alias clr
shopt -s nullglob
chkdir(){
    [ -d $1 ] && return
    [ -e $1 ] && { echo $C1"Not a directory $1"$C0;return 1; }
    /bin/mkdir $1
}
nouse(){
        [ "$1" ] || return
        chkdir ~/.trash || exit 1
        /bin/mv -fb $* ~/.trash
        /bin/ls -aF --color
}
nolink(){
    for i ; do
        [ -L $i -a ! -e $i ] || continue
        /bin/rm $i
        echo $C3"[${i##*/}] is not linked"$C0
    done
}
[ "$1" ] || set - .
for i;do
    chkdir $i || continue
    pushd $i >/dev/null
    nouse \#* *~ .*~ *.orig
    nolink * .*
    popd >/dev/null
done
