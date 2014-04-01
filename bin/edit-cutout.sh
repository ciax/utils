#!/bin/bash
#alias cutout
# Required scripts: func.app
# Required packages: coreutils(grep)
# Description: cutoutt matched lines from file and display
. func.app
_usage "[expression] [file]"
exp=$1;shift
file=$1;shift
_temp remain
egrep -v "$exp" $file > $remain 
egrep "$exp" $file
_overwrite $remain $file
