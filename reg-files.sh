#!/bin/bash
# Required packages: coreutils(readlink)
# Desctiption: Files in current dir will be classified into 'bin','db' ..
# "Usage: ${0##*/} [DIR..] | [SRC..]"
#alias rf

chklink(){
    # if dst file exists -> dst=regular file:>fail , dst=org link:>skip
    src=$1
    [ ! -e $2 ] && return 0 # Create or Overwrite unexist link
    [ -h $2 ] || { echo "Warning: $2 was regular file"; return 1; }
    dst=`readlink $2`
    [ "$src" != "$dst" ] || return 1
    echo "Warning: link of $2 is different from $src"
}

mklink(){
    [ "$1" = "-x" ] && { local xopt=$1;shift; }
    local objdir="$HOME/$1";shift
    [ -d "$objdir" ] || mkdir "$objdir"
    local list=''
    for i ; do
        [ -d "$i" -o ! -e "$i" ] && continue
        [ -h "$i" ] && { echo "$i is link and skip"; continue; }
        local base="${i##*/}"
        local real="$(pwd -P)/$base"
        if [ "$xopt" ] ; then
            local link="$objdir/${base%.*}"
            [ -x "$real" ] || continue
        else
            local link="$objdir/$base"
        fi
        chklink "$real" "$link" || continue
        ln -sf "$real" "$link"
        list="$list$base "
    done
    [ "$list" ] && echo "[ $list] -> $objdir"
    for i ; do
        [ -f $i ] || { rm $i; echo "link of [${i##*/}] was removed"; }
    done
}

shopt -s nullglob
for i in ${*:-. */}; do
    pushd $i >/dev/null
    mklink -x bin *.sh *.pl *.py *.rb *.awk *.exp *.js
    mklink lib lib*
    mklink db *.tsv *.csv
    mklink .emacs.d *.el
    popd >/dev/null
done
