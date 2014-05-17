#!/bin/bash
#alias wri
# Required scripts: func.temp
# Description: Overwrite if these are different.
. func.temp
_usage "[file] < (input)"
file=$1;shift
_temp temp
cat $* > $temp
_overwrite $temp $file
