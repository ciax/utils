#!/bin/bash
#alias wri
# Required scripts: func.getpar,func.temp
# Description: Overwrite if these are different.
. func.getpar
_usage "[file] < (input)"
file=$1;shift
. func.temp
_temp temp
cat $* > $temp
_overwrite $temp $file
