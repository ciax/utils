#!/bin/bash
#alias fil
# Required scripts: func.app
# Description: Overwrite if these are different.
. func.app
_usage "[file] [filter] (par)"
file=$1;shift
_temp temp
$* $file > $temp
_overwrite $temp $file
