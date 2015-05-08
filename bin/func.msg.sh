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
# Description: Print message to stderr
_msg(){ echo "$C2$*$C0" 1>&2; }
# Description: Print message to stderr
_warn(){ echo "$C3$*$C0" 1>&2; }
# Description: Print alert to stderr
_alert(){ echo "$C1$*$C0" 1>&2; }
# Desctiption: Abort with message
# Usage: _abort [message]
_abort(){ _alert "$*";exit 1; }
