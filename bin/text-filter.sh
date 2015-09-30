#!/bin/bash
# Required scripts: func.getpar
# Description: Overwrite if these are different.
#alias filter
. func.getpar
_usage "[file] [filter] (par)"
file=$1;shift
_temp temp
$* $file > $temp
_overwrite $file < $temp
