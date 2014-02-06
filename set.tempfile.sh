#!/bin/bash
# Required packages: coreutils(cat),diffutils(cmp)
# Usage: create_tempfile [varname1] [varname2] ..
create_tempfile(){
    local trp="rm -f -- "
    local i=
    for i ; do
    local tmp=$(tempfile) || { echo "Can't make mktemp"; exit 1; }
    local trp="$trp $tmp"
    eval "$i=$tmp"
    done
    trap "$trp" EXIT
}
# Usage: overwrite [src_file] [dst_file]
# Overwrite if these are different.
overwrite(){
    if cmp -s $1 $2 ; then
        rm $1;return 1
    else
        mv $1 $2
    fi
}
create_tempfile $*
