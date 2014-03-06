#!/bin/bash
# Restore backup file
#alias back
. set.usage "[file]" $1
[ "$1~" ] && /bin/mv $1~ $1
