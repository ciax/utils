#!/bin/bash
#alias back
# Description: restore backup file
. func.app
_usage "[file]"
[ "$1~" ] && /bin/mv $1~ $1
