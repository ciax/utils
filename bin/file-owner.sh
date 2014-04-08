#!/bin/bash
#alias chx
# Description: file owner will be uniformed under the current or specified dir tree
# Usage file-owner [dir..]
_chx(){
    local dir=${1:-.} SU=
    [ -d "$dir" ] || return 1
    local ug=$(stat -c "%U:%G" $dir)
    echo "`cd $dir;pwd -P`($ug)"
    sudo chown -R $ug $dir
}
echo $C3"Uniform Owner"$C0
if [ "$1" ] ;then
    for i ; do
        _chx $i
    done
else
    _chx .
fi
