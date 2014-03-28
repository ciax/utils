#!/bin/bash
#alias wri
# Required scripts: rc.app
# Required packages: coreutils(cat),diffutils(cmp)
# Description: Overwrite if these are different.
. rc.app
_usage "[file] < (input)"
file=$1;shift
_temp temp
cat $* > $temp
_overwrite $temp $file
