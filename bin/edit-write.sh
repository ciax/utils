#!/bin/bash
# Required scripts: func.usage,func.temp
# Required packages: coreutils(cat),diffutils(cmp)
# Overwrite if these are different.
#alias wri
. func.usage "[file] < (input)" $1
file=$1;shift
. func.temp temp
cat $* > $temp
overwrite $temp $file
