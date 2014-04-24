#!/bin/bash
# Description: move to subdirs recursively except symlinks and exec command
# Usage: $0 (command)
shopt -s nullglob
_subdirs(){
    local cmd="${*:-pwd -P}"
    for i in */ ;do
        [ -h "${i%/}" ] && continue
        (cd $i && { eval "$cmd"; _subdirs "$cmd"; } )
    done
}
