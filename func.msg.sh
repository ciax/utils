#!/bin/bash
# Display Message Module
# Usage:
#  souce $0 at head of file,
shopt -s nullglob
# Description: Print message to stderr
_msg(){ echo "$C2$*$C0" 1>&2; }
# Description: Print message to stderr
_warn(){ echo "$C3$*$C0" 1>&2; }
# Description: Print alert to stderr
_alert(){ echo "$C1$*$C0" 1>&2; }
# Desctiption: Abort with message
# Usage: _abort [message]
_abort(){ _alert "$*";exit 1; }
