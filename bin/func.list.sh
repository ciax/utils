#!/bin/bash
# Description: Listing from script files
type _list_csv >/dev/null 2>&1 && return
. func.file
#type -t _list_csv >/dev/null 2>&1 && return
shopt -s nullglob extglob
_list_csv(){ # Connect each line with ',' to csv line (a,b,c..) from <stdin>
    local line list
    while read line;do
        list+="${list:+,}$line"
    done
    echo "$list"
}
_add_list(){ # Add elemnt to ver without duplication [varname] [elements...] 
    # $1 must not be '_k' '_i' '_l' '_e'
    local _k=$1 _i _l _e;shift
    set - $(for _i in ${!_k} $*;do echo $_i;done|sort -u)
    eval "$_k=\"$*\""
    return $_e
}
_uniq(){ # Show uniq folded list without marked line from args
    local _i _ex tmplist
    _temp tmplist
    for _i ; do
        if [[ $_i =~ ^# ]] ; then
            _ex="${_ex:+$ex|}${_i#\#}"
        else
            echo $_i
        fi
    done > $tmplist
    if [ "$_ex" ] ; then
        egrep -v "^($_ex)$" $tmplist | sort -u
    else
        sort -u $tmplist
    fi
}
_colm(){ # Convert (item,desc) to folded list from <stdin>
    # if max width $1 is set, print multi column
    local width=${1:-1} ilen=0 clen=0 row
    # Get max line length
    mapfile -C __max -c 1 -t
    (( $ilen > 0 )) || return
    # Print lines
    row=$(( $width / $ilen + 1 ))
    set - "${MAPFILE[@]}"
    while (( $# > 0 )); do
        echo -en "\t"
        for (( i=0 ; i < $row && $# > 0 ; i++ )); do
            printf "%-${ilen}s " "$(_item "$1" $clen)"
            shift
        done
        echo
    done
}

__max(){
    (( ${#2} > $ilen )) && ilen=${#2}
    cap=${2%,*}
    (( ${#cap} > $clen )) && clen=${#cap}
}

_basename_list(){ # List of file basename
    set - "${@##*/}"
    echo -n "${@%.*}"
}
_chkfunc $*
