#!/bin/bash
#alias wri
# Required scripts: func.app
# Description: Overwrite if these are different.
. func.app
_usage "[file] < (input)"
file=$1;shift
_temp temp
cat $* > $temp
_overwrite $temp $file
