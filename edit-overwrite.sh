#!/bin/bash
# Required scripts: func.usage,set.tempfile
# Required packages: coreutils(cat),diffutils(cmp)
# Overwrite if these are different.
#alias ow
. func.usage "[file] [filter] (par)" $2
file=$1;shift
. set.tempfile temp
< $file $* > $temp
overwrite $temp $file && echo "Updated"
