#!/bin/bash
# Display Message Module
type _msg >/dev/null 2>&1 && return
shopt -s nullglob extglob
# Coloring for Console
#  ESC[(A);(B)(C)m # A: 0=dark 1=light # B: 3=FG 4=BG # C: 1=R 2=G 4=B
#  environment variable "C?","D?" are provided
if [ -t 2 ] ; then
    for i in 1 2 3 4 5 6 7 ; do
        eval "export C${i}=\$'\\e[1;3${i}m'"
        eval "export D${i}=\$'\\e[0;3${i}m'"
    done
    C0=$'\e[0m'
fi
_indent(){ # Indent multiple lines
    while read line; do
        echo "$INDENT$line" 1>&2
    done
}
_msg(){ # Print message to stderr
    echo -e "$C0$*$C0" | _indent
}
_warn(){ # Print warning to stderr
    echo -e "$C3$*$C0" | _indent
}
_alert(){ # Print alert to stderr
    echo -e "$C1$*$C0" | _indent
}
_abort(){ # Abort with message
    _alert "$*";exit 1
}
_item(){ # Show Items [caption,description,caption-length]
    if [[ "$1" =~ , ]] ; then
        cap=$(printf "%-${2:-1}s" "${1%%,*}")
        echo -en "$C2$cap$C0 : "
    fi
    echo -en "${1#*,}"
}
_verbose(){ # Show msg when func name is set to VER
    [ "$VER" ] && [[ "${FUNCNAME[*]}" =~ $VER ]] && _msg "$*"
}
_chkfunc(){ # Show function list in self file
    # Execute last one
    [ $0 == ${BASH_SOURCE[1]} ] || return
    local self="${0##*/}" i v
    echo $self
    # If this is symlinked to func name without '_', executed as func
    if [[ $(type _$self 2>&1) =~ function ]] ; then
        _$self $*
    else
        INDENT=$'\t'
        local cmd="$1";shift
        if [[ $(type "_$cmd" 2>&1) =~ function ]] ; then
            _$cmd $*
        else
            # function list
            while IFS='(#' read cap _ desc;do
                _item "${cap#_},$desc\n" | _indent
            done < <(grep "^_[-a-z_]\+(.*#" $0)
        fi
    fi
}
_chkfunc $*
