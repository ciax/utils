#!/bin/bash
# Required scripts: func.getpar
# Description: Modify return code to '\n' only.
#alias rmcr
. func.getpar
_usage "[files]"
_temp temp
for i; do
    tr -d $'\r' < $i > $temp
    _overwrite $i < $temp
done
