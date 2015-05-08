#!/bin/bash
# Display Message Module
# Usage:
#  souce $0 at head of file,
shopt -s nullglob
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
    echo "$C2$*$C0" 1>&2
}
_warn(){ # Print message to stderr
    echo "$C3$*$C0" 1>&2
}

_alert(){ # Print alert to stderr
    echo "$C1$*$C0" 1>&2
}

_abort(){ # Abort with message
    _alert "$*";exit 1
}
_item(){ # Show Items
    echo "   $C2$1$C0 : $2" 1>&2
}
# Show function list
_func_list(){
    [[ $0 == *$1 ]] || return
    echo "${0##*/} contains"
    grep "^[_a-z]\+(.*#" $0|while read l;do _item "${l%(*}" "${l#*#}";done
}
_func_list func.msg
