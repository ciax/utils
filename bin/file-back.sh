#!/bin/bash
#alias back
# Description: restore backup file
. src.app
_usage "[file]"
[ "$1~" ] && /bin/mv $1~ $1
