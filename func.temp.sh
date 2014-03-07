#!/bin/bash
# Required packages: coreutils(cat),diffutils(cmp)
# Usage: temp [varname1] [varname2] ..
temp(){
    local trp="/bin/rm -f -- "
    local i=
    for i ; do
	local tmp=$(tempfile) || { echo "Can't make mktemp"; exit 1; }
	tmplist="$tmplist $tmp"
	eval "$i=$tmp"
    done
    trap "$trp$tmplist" EXIT
}
# Usage: overwrite [src_file] [dst_file]
# Overwrite if these are different.
overwrite(){
    if cmp -s $1 $2 ; then
        /bin/rm $1;return 1
    else
        /bin/mv -b $1 $2
    fi
}
temp $*
