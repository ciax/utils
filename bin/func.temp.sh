#!/bin/bash
# Desctiption: makes temporaly files
# Usage: _temp [varname1] [varname2] ..
. func.msg
_tmplist=''
_temp(){ # Make temp file [name] ..
    local trp="rm -f -- " tmp i
    for i ; do
        tmp=$(mktemp) || _abort "Can't make mktemp"
        _tmplist="$_tmplist $tmp"
        eval "$i=$tmp"
    done
    trap "$trp$_tmplist" EXIT
}

_fuser(){ # Show file/dir owner [path]
    local dir=$1
    local cdir
    until [ -e "$dir" ] ; do
        cdir="${dir%/*}"
        [ "$cdir" = "$dir" ] && return 1
        dir="$cdir"
    done && echo $(stat -c %U $dir)
}

# Usage: _overwrite 
_overwrite(){ # Overwrite if these are different. [dst_file] < STDIN
    local user=$(_fuser $1) tmpfile
    _temp tmpfile
    cat > $tmpfile
    if [ ! -e $1 ] ; then
        local dir="$(dirname $1)"
        [ -e "$dir" ] || sudo -u $user mkdir -p "$dir"
        sudo mv $tmpfile $1
        sudo chown $user $1
    elif sudo cmp -s $tmpfile $1 ; then
        return 1
    else
        [ -d ~/.trash ] || mkdir -p ~/.trash
        chmod --reference=$1 $tmpfile
        sudo mv -b $1 ~/.trash/ && sudo mv $tmpfile $1
        sudo chown $user $1
    fi
}

_cutout(){ # cutoutt matched lines from file and display [expression] [file]
    local remain exp="$1" file="$2"
    _temp remain
    egrep -v "$exp" $file > $remain
    egrep "$exp" $file
    _overwrite $file < $remain
}
_chkfunc $*
