#!/bin/bash
# Description: Listing from script files
type _list_csv >/dev/null 2>&1 && return
. func.temp
#type -t _list_csv >/dev/null 2>&1 && return
shopt -s nullglob extglob
_list_csv(){ # Connect each line with ',' to csv line (a,b,c..) from <stdin>
    local line list
    while read line;do
        list="${list:+$list,}$line"
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
    local size=0 tmplist item
    local width=$1 len=0
    _temp tmplist
    # Get max line length
    while read item;do
        [ "${#item}" -gt $size ] && size="${#item}"
        echo "$item"
    done > $tmplist
    # Print lines
    while read item;do
        [[ "$item" =~ , ]] && item=$(_item "$item")
        if [ "$width" ]; then
            [ $len = 0 ]  && echo -en "\t"
            printf "%-${size}s " "$item"
            len=$(( $len + $size ))
            if [ $len -gt $width ] ; then
                echo
                len=0
            fi
        else
            echo -e "\t$item"
        fi
    done < $tmplist
    [ $len -gt 0 ] && echo
}
_basename_list(){ # List of file basename
    for i ;do
        f=${i##*/}
        echo -n "${f%.*} "
    done
}
_chkfunc $*
