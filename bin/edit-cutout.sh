#!/bin/bash
#alias cutout
# Required commands: grep
# Required scripts: func.app
# Description: cutoutt matched lines from file and display
. func.app
_usage "[expression] [file]"
exp=$1;shift
file=$1;shift
_temp remain
egrep -v "$exp" $file > $remain 
egrep "$exp" $file
_overwrite $remain $file
