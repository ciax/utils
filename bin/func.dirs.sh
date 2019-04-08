#!/bin/bash
# Description: move to subdirs recursively except symlinks then execute command there
#     _exdir=: excluding dirs
#    _dirlist: csv list of dir
#
type _subdirs >/dev/null 2>&1 && return
. func.msg
_topdir="$PWD/"
_subdirs(){ # Scan SubDir and Exec Cmd there
    local cmd="${*:-pwd -P}"
    eval "$cmd"
    local dir="${PWD#*$_topdir}"
    _dirlist+=",${dir/$HOME/~}"
    shopt -s nullglob
    local i
    for i in */ ;do
        [ -h "${i%/}" ] && continue
        [ "$_exdir" ] && [[ "${i%/}" =~ "$_exdir" ]] && continue
        pushd "$i" >/dev/null
        _subdirs "$cmd"
        popd >/dev/null
    done
}
_chkfunc $*
