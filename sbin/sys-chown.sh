#!/bin/bash
#alias chx
# Usage dir-chown [dir..]
# Description: File owner will be uniformed under the current or specified dir tree
. func.sudo
_warn "Uniform The Owner"
for dir in ${*:-.}; do
    [ -d "$dir" ] || continue
    ug=$(stat -c "%U:%G" $dir)
    echo "`cd $dir;pwd -P`($ug)"
    _sudy chown -R $ug $dir
done

