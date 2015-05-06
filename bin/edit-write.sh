#!/bin/bash
#alias wri
# Required scripts: func.getpar
# Description: Overwrite if these are different.
. func.getpar
_usage "[file] < (input)"
file=$1;shift
_temp temp
cat $* > $temp
_overwrite $temp $file
