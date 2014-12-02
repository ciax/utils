#!/bin/bash
# Desctiption: makes temporaly files
# Usage: _temp [varname1] [varname2] ..
. func.getpar
_temp(){
    local trp="/bin/rm -f -- "
    local i=
    for i ; do
        local tmp=$(mktemp) || { echo "Can't make mktemp"; exit 1; }
        _tmplist="$_tmplist $tmp"
        eval "$i=$tmp"
    done
    trap "$trp$tmplist" EXIT
}

# Description: Overwrite if these are different.
# Usage: _overwrite [src_file] [dst_file]
_overwrite(){
    if [ ! -e $2 ] ; then
        /bin/mv $1 $2
    elif cmp -s $1 $2 ; then
        /bin/rm $1;return 1
    else
        local dir="$(dirname $2)"
        [ -e "$dir" ] || mkdir -p "$dir"
        [ -d ~/.trash ] || mkdir -p ~/.trash
        chmod --reference=$2 $1
        /bin/mv -b $2 ~/.trash/ && /bin/mv $1 $2
    fi
}
