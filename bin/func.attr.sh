#!/bin/bash
#link chx
#link setp
# Usage file-owner [dir..]
. func.msg
_chx(){ # File owner will be uniformed under the current or specified dir tree
    _warn "Uniform The Owner"
    for dir in ${*:-.}; do
        [ -d "$dir" ] || continue
        local ug=$(stat -c "%U:%G" $dir)
        echo "`cd $dir;pwd -P`($ug)"
        sudo chown -R $ug $dir
    done
}
_setp(){ # Set permission [oct] [files..]
    local oct=$1 pm file;shift
    for file; do
        [ -e $file ] || continue
        if [ $(stat -c%a $file) != "$oct" ]; then
            chmod $oct $file
            _warn "Permission for $file is changed to $oct"
        fi
    done
}
_chkfunc $*
