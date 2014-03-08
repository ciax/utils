#!/bin/bash
# Required packages: coreutils(readlink)
# Required scripts: file-clean
# Desctiption: Files in current dir will be classified into 'bin','db' ..
# "Usage: ${0##*/} [DIR..] | [SRC..]"
addlist(){
    if [[ "$1" =~ / ]]; then
	local dir=${1%/*}
    else
	local dir=$(pwd -P)
    fi
    dirlist[$dir]="${dirlist[$dir]} ${1##*/}"
}
showlist(){
    for i in ${!dirlist[*]};do
	echo "[${dirlist[$i]} ] -> $C1$i$C0"
    done
}
makelink(){
    src=$1;dst=$2
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
            local link="${base%.*}"
            [ -x "$real" ] || continue
        else
            local link="$base"
        fi
	# extra link should be described as #link head
	pushd $objdir > /dev/null
	for j in "$link" $(grep '^#link' "$real"|cut -d' ' -f2-);do
	    eval "k=$j" # Fop tilde expansion
            makelink "$real" "$k"
	done
	popd > /dev/null
    done
}
dirreg(){
    declare -A dirlist
    for i ; do
        pushd $i >/dev/null
        link2dir -x bin *.sh *.pl *.py *.rb *.awk *.exp *.js
        link2dir lib lib*
        link2dir db *.tsv *.csv
        link2dir .emacs.d *.el
        dirreg */
        popd >/dev/null
    done
    showlist
}
shopt -s nullglob
dirreg ~/utils ~/cfg.* $*
~/bin/file-clean ~/bin ~/db ~/lib ~/.var
