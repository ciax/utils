#!/bin/bash
# Description: restore backup file
#alias back
_usage "[file]" $1
[ "$1~" ] && /bin/mv $1~ $1
