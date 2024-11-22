#!/bin/bash
# Required scripts: func.getpar
# Description: Remove Control codes.
#alias rmcl
. func.getpar
_usage "[files]"
_temp temp
for i; do
    tr -d '\000-\010\013-\037' > $temp
    _overwrite $i < $temp
done
