#!/bin/bash
# Desctiption: makes temporaly files
# Usage: _temp [varname1] [varname2] ..
. func.msg
_temp(){ # Make temp file [name] ..
    local trp="rm -f -- "
    local i=
    for i ; do
        local tmp=$(mktemp) || _abort "Can't make mktemp"
        _tmplist="$_tmplist $tmp"
        eval "$i=$tmp"
    done
    trap "$trp$_tmplist" EXIT
}

_fuser(){ # Show file/dir owner [path]
    dir=$1
    until [ -e "$dir" ] ; do
        cdir="${dir%/*}"
        [ "$cdir" = "$dir" ] && return 1
        dir="$cdir"
    done && echo $(stat -c %U $dir)
}

# Usage: _overwrite 
_overwrite(){ # Overwrite if these are different. [src_file] [dst_file]
    user=$(_fuser $2)
    if [ ! -e $2 ] ; then
        sudo mv $1 $2
        sudo chown $user $2
    elif sudo cmp -s $1 $2 ; then
        rm $1;return 1
    else
        local dir="$(dirname $2)"
        [ -e "$dir" ] || sudo -u $user mkdir -p "$dir"
        [ -d ~/.trash ] || mkdir -p ~/.trash
        chmod --reference=$2 $1
        sudo mv -b $2 ~/.trash/ && sudo mv $1 $2
        sudo chown $user $2
    fi
}
_chkfunc $*
