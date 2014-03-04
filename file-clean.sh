#!/bin/bash
shopt -s nullglob
chkdir(){
    [ -d $1 ] && return
    [ -e $1 ] && { echo "Not a directory $1";return 1; }
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
        echo "[${i##*/}] is not linked"
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
