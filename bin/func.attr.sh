#!/bin/bash
#link chx
# Usage file-owner [dir..]
. func.msg
_chx(){ #file owner will be uniformed under the current or specified dir tree
    _warn "Uniform The Owner"
    for dir in ${*:-.}; do
        [ -d "$dir" ] || continue
        local ug=$(stat -c "%U:%G" $dir)
        echo "`cd $dir;pwd -P`($ug)"
        sudo chown -R $ug $dir
    done
}
_chkfunc $*
