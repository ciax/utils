#!/bin/bash
shopt -s nullglob
nouse(){
        [ "$1" ] || return
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
nouse \#* *~ .*~ *.orig
nolink * .*
