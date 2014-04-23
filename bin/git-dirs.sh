#!/bin/bash
# Description: dirlist that has .git
shopt -s nullglob
showdir(){
    cd $1
    for i in */ ;do
        [ -h ${i%/} ] && continue
        if [ -e "$i.git" ] ; then
            (cd $i;pwd -P)
        else
            (showdir $i)
        fi
    done
}
showdir ~
