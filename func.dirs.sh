#!/bin/bash
# Description: move to subdirs recursively except symlinks and execute command there
#              Use $sep for csv description (ex. list+=$sep$str)
shopt -s nullglob
defsep=,
_subdirs(){
    local cmd="${1:-pwd -P}"
    local sep=$2
    eval "$cmd"
    for i in */ ;do
        [ -h "${i%/}" ] && continue
        ( cd $i && _subdirs "$cmd" "$defsep" )
    done
}
