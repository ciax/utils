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
_colm(){ # Convert csv to folded list from <stdin>
    local size=0 tmplist item line
    _temp tmplist
    while read item;do
        [ "${#item}" -gt $size ] && size="${#item}"
        echo "$item"
    done > $tmplist
    while read item;do
        [[ "$item" =~ , ]] && item="$C2${item/,/$C0: }"
        while [ ${#item} -lt $size ]; do
            item="$item "
        done
        line="$line\t$item"
        if [ "${#line}" -gt 40 ] ; then
            echo -e "${line% *}"
            unset line
        fi
    done < $tmplist
    [ "$line" ] && echo -e "$line"
}
_caselist(){ # List of case option
    egrep -o '^ +[a-z]+\)' $0|tr -d ' )'
}
_disp-case(){ # Display case list and exit
    local line arg
    egrep '^ +[a-z]+\)' $0 |\
    while read line;do
        arg="${line%%)*}"
        echo -n "${arg#* }"
        [[ "$line" =~ '#' ]] && echo ",${line#*#}" || echo
    done | _colm
}
_optlist(){ # List of options with opt-?() functions
    local line fnc desc
    egrep '^x?opt-.\(\)\{' $0|\
    while read line;do
        fnc="${line%%(*}"
        [[ "$line" =~ '#' ]] && desc=":${line#*#}"
        echo $C2"${fnc#*opt}$C0${desc/:=/=}"
    done
}
_basename_list(){ # List of file basename
    for i ;do
        f=${i##*/}
        echo -n "${f%.*} "
    done
}
_chkfunc $*
