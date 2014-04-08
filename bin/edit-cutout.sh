#!/bin/bash
#alias cutout
# Required scripts: func.getpar,func.temp
# Description: cutoutt matched lines from file and display
. func.getpar
_usage "[expression] [file]"
exp=$1;shift
file=$1;shift
. func.temp
_temp remain
egrep -v "$exp" $file > $remain
egrep "$exp" $file
_overwrite $remain $file
