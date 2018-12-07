#!/bin/bash
# Description: file handling library
type _temp >/dev/null 2>&1 && return
source func.msg
mkdir -p ~/.trash
TEMPLIST=''
_temp(){ # Make temp file [name] ..
    local trp="rm -f -- " tmp i
    for i ; do
        local tmp=$(mktemp) || _abort "Can't make mktemp"
        chmod 644 $tmp
        TEMPLIST="$TEMPLIST $tmp"
        eval "$i=$tmp"
    done
    trap "$trp$TEMPLIST" EXIT
}
_fuser(){ # Show file/parent dir's owner [path]
    local dir=$1 cdir
    until [ -e "$dir" ] ; do
        cdir="${dir%/*}"
        [ "$cdir" = "$dir" ] && return 1
        dir="$cdir"
    done && echo $(stat -c %U $dir)
}

_delegate(){ # do something as a user
    $*
}
# Usage: _overwrite
# Overwrite if these are different. [dst_file] <src_file>, return 1 if no changes
# The command of 'install' will force to change the permittion of dst file
_overwrite(){ 
    local dstfile=$1 srcfile=$2 user dir
    [ "$dstfile" ] || _abort "No dst_file"
    [ "$srcfile" ] || _temp srcfile
    __input_src "$srcfile"
    __prepare_dst "$dstfile"
    if cmp -s  $srcfile $dstfile ; then
        rm -f $srcfile
        return 1
    else
        _verbose "file diff" && diff $dstfile $srcfile 1>&2
        chmod --reference=$dstfile $srcfile
        cp -b $dstfile ~/.trash/ || _warn "Failed backup $dstfile"
        _delegate mv $srcfile $dstfile
    fi
}
# __input_src [tempfile]
__input_src(){
    [ -e "$1" ] || _abort "No src_file"
    if [ ! -t 0 ] ; then # For stdin
        cat > $1
    elif [ ! -s $1 ] ; then
        _abort "Input file is empty"
    fi
}
# __prepare_dst [filepath]
__prepare_dst(){ # make file if not exist
     [ -e $1 ]  && return
     _delegate mkdir -p "$(dirname $1)"
     _delegate touch $1
     _warn "$1 is created"
}

_cutout(){ # split file by expression (matched -> stdout, unmatched -> file) [expression] [file]
    local remain exp="$1" file="$2"
    _temp remain
    egrep -v "$exp" $file > $remain
    egrep "$exp" $file
    _overwrite $file < $remain
}

_insert(){ # comment out and insert line after the original line [file] [exp] (par)
    local dstfile=$1;shift
    local line="$1 $2 #inserted_by_user"
    if grep -q "$line" $dstfile; then
        _warn "Already exist"
    else
        _temp tmpfile
        local ln=$(grep -n -m1 "^#$1" $dstfile|cut -d: -f1)
        sed -e "${ln}a $line" $dstfile > $tmpfile
        _overwrite $dstfile $tmpfile
    fi
}

_chkfunc $*
