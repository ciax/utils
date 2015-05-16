#!/bin/bash
# Desctiption: makes temporaly files
# Usage: _temp [varname1] [varname2] ..
#link overwrite
. func.msg
[ -d ~/.trash ] || mkdir -p ~/.trash
TEMPLIST=''
_temp(){ # Make temp file [name] ..
    local trp="rm -f -- " tmp i
    for i ; do
        tmp=$(mktemp) || _abort "Can't make mktemp"
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
_overwrite(){ # Overwrite if these are different. [dst_file] <src_file>
    local dstfile=$1 srcfile=$2 user dir
    [ "$dstfile" ] || _abort "No dst_file"
    if [ ! -t 0 ] ; then
        _temp srcfile
        cat > $srcfile
    elif [ ! "$srcfile" ] ; then
        _abort "No src_file"
    fi
    if [ ! -e $dstfile ] ; then
        dir=$(dirname $dstfile)
        user=$(_fuser $dir)
        sudo -u $user mkdir -p "$dir"
        sudo mv $srcfile $dstfile
        sudo chown $user $dstfile
        _warn "$dstfile is created"
    elif sudo cmp -s $srcfile $dstfile ; then
        rm $srcfile
        return 1
    else
        user=$(_fuser $dstfile)
        chmod --reference=$dstfile $srcfile
        sudo mv -b $dstfile ~/.trash/ || _warn "Failed backup $dstfile"
        sudo mv $srcfile $dstfile
        sudo chown $user $dstfile
        _warn "$dstfile is changed"
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
