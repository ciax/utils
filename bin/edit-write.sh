#!/bin/bash
#alias wri
# Required scripts: func.getpar
# Description: Overwrite if these are different.
. func.getpar
_usage "[file] < (input)"
file=$1;shift
cat $* | _overwrite $file
