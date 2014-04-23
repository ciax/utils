#!/bin/bash
# Description: move to subdirs recursively except symlinks and exec command
# Usage: $0 (command)
shopt -s nullglob
cmd="${*:-pwd -P}"
recdir(){
    [ -h "${1%/}" ] && return
    cd $1 || return
    eval "$cmd"
    for i in */ ;do
        (recdir $i)
    done
}
recdir .
