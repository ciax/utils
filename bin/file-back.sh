#!/bin/bash
#alias back
# Required scripts: func.getpar
# Description: restore backup file
. func.getpar
_usage "[file]"
[ "$1~" ] && /bin/mv $1~ $1
