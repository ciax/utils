#!/bin/bash
# Description: using sudo library
type _sudy >/dev/null 2>&1 && return
# SUDOR?
_sudy(){ # sudo with check
    which sudo >/dev/null || _abort "Need 'sudo' installed or to be root"
    egrep -q "^(sudo|wheel):.*[,:]$LOGNAME" /etc/group || _abort "No sudo permission"
    [ "$PASSWORD" ] && echo $PASSWORD | sudo -S $* || sudo $*
}

### Config file handlint ###
_fuser(){ # Show file/parent dir's owner [path]
    local dir=$1 cdir
    until [ -e "$dir" ] ; do
        cdir="${dir%/*}"
        [ "$cdir" = "$dir" ] && return 1
        dir="$cdir"
    done && echo $(stat -c %U $dir)
}
# The command of 'install' will force to change the permittion of dst file
# Override func.file#_overwrite()
_overwrite(){ # Overwrite for system file
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
