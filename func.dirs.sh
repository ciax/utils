#!/bin/bash
# Description: move to subdirs recursively except symlinks and exec command
# Usage: $0 (command)
shopt -s nullglob
_subdirs(){
    local cmd="${*:-pwd -P}"
    eval "$cmd"
    for i in */ ;do
        [ -h "${i%/}" ] && continue
        ( cd $i && _subdirs "$cmd" )
    done
}
