#!/bin/bash
#alias back
# Description: restore backup file
. rc.app
_usage "[file]" $1
[ "$1~" ] && /bin/mv $1~ $1
