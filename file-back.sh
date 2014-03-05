#!/bin/bash
# Restore backup file
#alias back
[ "$1" ] || . set.usage "[file]"
[ "$1~" ] && /bin/mv $1~ $1
