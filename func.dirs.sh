#!/bin/bash
# Description: move to subdirs recursively except symlinks and execute command there
#              Use $sep for csv description (ex. list+=$sep$str)
shopt -s nullglob
_defsep=,
_topdir="$PWD/"
_dirlist=
_subdirs(){
    local cmd="${1:-pwd -P}"
    local sep=$2
    eval "$cmd"
    local dir="${PWD#*$_topdir}"
    _dirlist+="$sep${dir/$HOME/~}"
    local i
    for i in */ ;do
        [ -h "${i%/}" ] && continue
        pushd $i >/dev/null
        _subdirs "$cmd" "$_defsep"
        popd >/dev/null
    done
}