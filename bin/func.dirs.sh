#!/bin/bash
# Description: move to subdirs recursively except symlinks then execute command there
#              Use $sep for csv description (ex. list+=$sep$str)
. func.msg
_defsep=,
_topdir="$PWD/"
#_dirlist=
#_exdir=
_subdirs(){ # Scan SubDir and Exec Cmd there
    local cmd="${1:-pwd -P}"
    local sep=$2
    eval "$cmd"
    local dir="${PWD#*$_topdir}"
    _dirlist+="$sep${dir/$HOME/~}"
    local i
    shopt -s nullglob
    for i in */ ;do
        [ -h "${i%/}" ] && continue
        [ "$_exdir" ] && [[ "${i%/}" =~ "$_exdir" ]] && continue
        pushd "$i" >/dev/null
        _subdirs "$cmd" "$_defsep"
        popd >/dev/null
    done
}
_chkfunc $*
