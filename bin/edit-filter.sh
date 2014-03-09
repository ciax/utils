#!/bin/bash
# Required scripts: func.usage,func.temp
# Required packages: coreutils(cat),diffutils(cmp)
# Overwrite if these are different.
#alias wri
. func.usage "[file] [filter] (par)" $2
file=$1;shift
. func.temp temp
$* $file > $temp
overwrite $temp $file
