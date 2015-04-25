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
    trap "$trp$_tmplist" EXIT
}

# Show file/dir owner
_fuser(){
    dir=$1
    until [ -e "$dir" ] ; do
        cdir="${dir%/*}"
        [ "$cdir" = "$dir" ] && return 1
        dir="$cdir"
    done && echo $(stat -c %U $dir)
}

# Description: Overwrite if these are different.
# Usage: _overwrite [src_file] [dst_file]
_overwrite(){
    user=$(_fuser $2)
    if [ ! -e $2 ] ; then
        sudo /bin/mv $1 $2
        sudo chown $user $2
    elif sudo cmp -s $1 $2 ; then
        /bin/rm $1;return 1
    else
        local dir="$(dirname $2)"
        [ -e "$dir" ] || sudo -u $user mkdir -p "$dir"
        [ -d ~/.trash ] || mkdir -p ~/.trash
        chmod --reference=$2 $1
        sudo /bin/mv -b $2 ~/.trash/ && sudo /bin/mv $1 $2
        sudo chown $user $2
    fi
}
