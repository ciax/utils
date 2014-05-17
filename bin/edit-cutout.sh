#!/bin/bash
#alias cutout
# Required scripts: func.temp
# Description: cutoutt matched lines from file and display
. func.temp
_usage "[expression] [file]"
exp=$1;shift
file=$1;shift
_temp remain
egrep -v "$exp" $file > $remain
egrep "$exp" $file
_overwrite $remain $file
