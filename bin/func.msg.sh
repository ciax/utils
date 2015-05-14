#!/bin/bash
# Display Message Module
type _chkfunc >/dev/null 2>&1 && return
shopt -s nullglob extglob
# Coloring for Console
#  ESC[(A);(B)(C)m # A: 0=dark 1=light # B: 3=FG 4=BG # C: 1=R 2=G 4=B
#  environment variable "C?" are provided
if [ -t 2 ] ; then
    for i in 1 2 3 4 5 6 7 ; do
        eval "export C${i}=\$'\\e[1;3${i}m'"
    done
    C0=$'\e[0m'
fi

_msg(){ # Print message to stderr
    echo "$INDENT$C2$*$C0" 1>&2
}
_warn(){ # Print message to stderr
    echo "$INDENT$C3$*$C0" 1>&2
}
_alert(){ # Print alert to stderr
    echo "$INDENT$C1$*$C0" 1>&2
}
_abort(){ # Abort with message
    _alert "$*";exit 1
}
_item(){ # Show Items [title] [description]
    echo "$INDENT$C2$1$C0 : $2" 1>&2
}
_list_csv(){ # Show lined list (a,b,c..)
    local line list
    while read line;do
        list="${list:+$list,}$line"
    done
    echo "$list"
}
_add_list(){ # Add elemnt to ver without duplication [varname] [elements...] 
    # $1 must not be '_k' '_i' '_l' '_e'
    local _k=$1 _i _l _e;shift
    for _i in ${!_k} $*;do
        if [[ "$_l" =~ (^|' ')$_i' ' ]]; then
            _e=1
        else
            _l+="$_i "
        fi
    done
    eval "$_k=\"${_l% }\""
    return $_e
}
_chkfunc(){ # Show function list
    local self="${0##*/}"
    # If this is symlinked to func name without '_', executed as func
    if [[ $(type _$self 2>&1) =~ function ]] ; then
        _$self $*
    elif [ $0 == ${BASH_SOURCE[1]} ] ; then
        echo "$self contains"
        INDENT=$'\t'
        grep "^_[-a-z]\+(.*#" $0|\
            while read l;do
                _item "${l%%(*}" "${l#*#}"
            done
    fi
}
_chkfunc $*
