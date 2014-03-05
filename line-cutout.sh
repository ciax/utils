#!/bin/bash
# Required script: set.usage, set.tempfile
# Required packages: coreutils(grep)
# Cutout matched line from file
#alias cutout
[ "$2" ] || . set.usage "[expression] [file]"
exp=$1;shift
file=$1;shift
. set.tempfile remain
egrep -v "$exp" $file > $remain 
egrep "$exp" $file
overwrite $remain $file