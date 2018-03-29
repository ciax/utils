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

# Usage: _overwrite 
_overwrite(){ # Overwrite if these are different. [dst_file] <src_file>, return 1 if no changes
    local dstfile=$1 srcfile=$2 user dir
    [ "$dstfile" ] || _abort "No dst_file"
    [ -s $srcfile ] || _abort "Input file is empty"
    if [ ! -t 0 ] ; then
        _temp srcfile
        cat > $srcfile
    elif [ ! "$srcfile" ] ; then
        _abort "No src_file"
    fi
    if [ ! -e $dstfile ] ; then
        dir=$(dirname $dstfile)
        mkdir -p "$dir"
        mv $srcfile $dstfile
        _warn "$dstfile is created"
    elif cmp -s $srcfile $dstfile ; then
        rm -f $srcfile
        return 1
    else
        _verbose "file diff" && diff $dstfile $srcfile 1>&2
        chmod --reference=$dstfile $srcfile
        mv -b $dstfile ~/.trash/ || _warn "Failed backup $dstfile"
        mv $srcfile $dstfile
    fi
}

_overwrite_s(){ # Overwrite for system file
    local dstfile=$1 srcfile=$2 user dir
    [ "$dstfile" ] || _abort "No output file specified"
    [ -s $srcfile ] || _abort "Input file is empty"
    if [ ! -e $dstfile ] ; then
        dir=$(dirname $dstfile)
        user=$(_fuser $dir)
        sudo -u $user mkdir -p "$dir"
        sudo mv $srcfile $dstfile
        sudo chown $user $dstfile
        _warn "$dstfile is created"
    elif sudo cmp -s $srcfile $dstfile ; then
        rm -f $srcfile
        _warn "No changes on $dstfile"
        return 1
    else
        user=$(_fuser $dstfile)
        _verbose "file diff" && diff $dstfile $srcfile 1>&2
        chmod --reference=$dstfile $srcfile
        sudo mv -b $dstfile ~/.trash/ || _warn "Failed backup $dstfile"
        sudo mv $srcfile $dstfile
        sudo chown $user $dstfile
        _warn "$dstfile is modified"
    fi
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
        _overwrite_s $dstfile $tmpfile
    fi
}

_chkfunc $*
