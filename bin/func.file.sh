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
# Overwrite if these are different. Return 1 if no changes.
# The command of 'install' will force to change the permittion of org file
_overwrite(){ # overwrite if different  [org_file] <tmp_file>
    local org_file=$1 tmp_file=$2
    [ "$org_file" ] || _abort "No org_file"
    [ "$tmp_file" ] || _temp tmp_file
    __input_tmp "$tmp_file"
    [ -h "$org_file" ] && org_file="$(realpath $org_file)"
    [ "$org_file" = "$(realpath $tmp_file)" ] && _abort "Same file"
    user=$(_fuser $org_file)
    __prepare_org "$org_file"
    if cmp -s  $tmp_file $org_file ; then
        rm -f $tmp_file
        _warn "No changes on $org_file"
        return 1
    else
        _verbose "file diff" && diff $org_file $tmp_file 1>&2
        chmod --reference=$org_file $tmp_file
        cp -b $org_file ~/.trash/ || _warn "Failed backup $org_file"
        _delegate cp $tmp_file $org_file
        _warn "$org_file is modified"
    fi
}
# __input_tmp [tempfile]
__input_tmp(){
    [ -e "$1" ] || _abort "No tmp_file"
    if [ -t 0 ] ; then # For stdin
        tee > $1
    elif [ ! -s $1 ] ; then
        _abort "Input file is empty"
    fi
}
# __prepare_org [filepath]  : make file if not exist
__prepare_org(){
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
