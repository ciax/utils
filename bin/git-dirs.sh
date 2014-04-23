#!/bin/bash
# Description: dirlist that has .git
shopt -s nullglob
showdir(){
    [ -h "${1%/}" ] && return
    cd $1 || return
    if [ -d ".git" ] ; then
        pwd -P
    else
        for i in */ ;do
            (showdir $i)
        done
    fi
}
showdir ~
