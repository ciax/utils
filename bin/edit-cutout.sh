#!/bin/bash
#alias cutout
# Required scripts: rc.app
# Required packages: coreutils(grep)
# Description: cutoutt matched lines from file and display
. rc.app
_usage "[expression] [file]" $2
exp=$1;shift
file=$1;shift
_temp remain
egrep -v "$exp" $file > $remain 
egrep "$exp" $file
_overwrite $remain $file
