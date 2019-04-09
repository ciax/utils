#!/bin/bash
# Description: move to subdirs recursively except symlinks then execute command there
#     _exdir=: excluding dirs
#    _dirlist: csv list of dir
#
type _subdirs >/dev/null 2>&1 && return
. func.msg
shopt -s nullglob
_do_here(){
    local cmd="${*:-pwd -P}"
    eval "$cmd"
    local dir="$(pwd -P)"
    _dirlist+="${_dirlist:+,}~${dir#$HOME}"
}
# Scan SubDir and Exec Cmd there
_subdirs(){
    _do_here "$*"
    local i
    for i in */ ;do
        [ -h "${i%/}" ] && continue
        [ "$_exdir" ] && [[ "${i%/}" =~ "$_exdir" ]] && continue
        pushd "$i" >/dev/null
        _subdirs "$*"
        popd >/dev/null
    done
}
_chkfunc $*
