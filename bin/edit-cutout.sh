#!/bin/bash
# Required scripts: func.usage, func.temp
# Required packages: coreutils(grep)
# Cutout matched line from file
#alias cutout
. func.usage "[expression] [file]" $2
exp=$1;shift
file=$1;shift
. func.temp remain
egrep -v "$exp" $file > $remain 
egrep "$exp" $file
overwrite $remain $file
