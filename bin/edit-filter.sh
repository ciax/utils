#!/bin/bash
#alias fil
# Required scripts: src.app
# Required packages: coreutils(cat),diffutils(cmp)
# Description: Overwrite if these are different.
. src.app
_usage "[file]" "[filter] (par)"
file=$1;shift
_temp temp
$* $file > $temp
_overwrite $temp $file
