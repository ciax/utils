#!/bin/bash
# Required scripts: file-clean
# Description: make links to the specific dirs categorized by file type 
# Desctiption: Files in current dir will be classified into 'bin','db' ..
# "Usage: ${0##*/} [DIR..] | [SRC..]"
addlist(){
    local dir="${1%/*}"
    dirlist[$dir]="${dirlist[$dir]} ${1##*/}"
}
showlist(){
    for i in ${!dirlist[*]};do
        echo "[${dirlist[$i]} ] -> $C1$i$C0"
    done
}
makelink(){
    local src=$1
    local dst=$2
    # if dst file exists -> dst=regular file:>fail , dst=org link:>skip
    # Create or Overwrite unexist link
    if [ -e $dst ] ; then
        [ -h $dst ] || { echo $C1"Error: $dst is regular file"$C0; return 1; }
        [ "$src" = `readlink $dst` ] && return
        echo $C3"Warning: link of $dst is different from $src"$C0
    fi
    ln -sf $src $dst || return 1
    addlist $dst
}
extlink(){
    egrep "^#link(:$DIST| )" "$1"|cut -d' ' -f2-
}
link2dir(){
    [ "$1" = "-x" ] && { local xopt=$1;shift; }
    local objdir="$HOME/$1";shift
    [ -d "$objdir" ] || mkdir "$objdir"
    local list=''
    for i ; do
        [ -d "$i" -o ! -e "$i" ] && continue
        [ -h "$i" ] && { echo $C3"$i is link and skip"$C0; continue; }
        local base="${i##*/}"
        local real="$(pwd -P)/$base"
        if [ "$xopt" ] ; then
            base="${base%.*}"
            [ -x "$real" ] || continue
        fi
        # extra link should be described as #link head
        for j in "$base" $(extlink "$real");do
            if [[ "$j" =~ / ]] ; then
                # eval: for tilde expansion
                eval "dst=$j"
            else
                local dst="$objdir/$j"
            fi
            makelink "$real" "$dst"
        done
    done
}
dirreg(){
    [ "$1" ] || return
    declare -A dirlist
    for i ; do
        pushd $i >/dev/null
        link2dir -x bin *.sh *.pl *.py *.rb *.awk *.exp *.js
        link2dir lib lib*
        link2dir .emacs.d *.el
        dirreg */
        popd >/dev/null
    done
    showlist
}
shopt -s nullglob
echo $C3"File Registering"$C0
dirreg ~/utils ~/cfg.*/ $*
file-clean ~/bin ~/lib ~/db ~/.var
