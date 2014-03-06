#!/bin/bash
# Required script: set.usage, set.tempfile
# Required packages: coreutils(grep)
# Cutout matched line from file
#alias cutout
. set.usage "[expression] [file]" $2
exp=$1;shift
file=$1;shift
. set.tempfile remain
egrep -v "$exp" $file > $remain 
egrep "$exp" $file
overwrite $remain $file