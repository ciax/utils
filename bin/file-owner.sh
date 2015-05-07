#!/bin/bash
#alias chx
# Description: file owner will be uniformed under the current or specified dir tree
# Usage file-owner [dir..]
. func.msg
_chx(){
    local dir=${1:-.} SU=
    [ -d "$dir" ] || return 1
    local ug=$(stat -c "%U:%G" $dir)
    echo "`cd $dir;pwd -P`($ug)"
    sudo chown -R $ug $dir
}
_warn "Uniform Owner"
if [ "$1" ] ;then
    for i ; do
        _chx $i
    done
else
    _chx .
fi
