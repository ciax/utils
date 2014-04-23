#!/bin/bash
# Description: recursive dirs
shopt -s nullglob
cmd="${*:-pwd -P}"
showdir(){
    [ -h "${1%/}" ] && return
    cd $1 || return
    eval "$cmd"
    for i in */ ;do
        (showdir $i)
    done
}
showdir ~
