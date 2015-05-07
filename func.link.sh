#!/bin/bash
# Description: make links of files
# if dst file exists -> dst=regular file:>fail , dst=org link:>skip
# Create or Overwrite unexist link
_absdir(){
    local dir="${1%/*}"
    [ -d "$dir" ] || mkdir -p "$dir"
    cd "$dir";pwd -P
}
_abspath(){ # absdir filename
    eval "local apath=$1"
    [ -h "$apath" ] && apath=$(readlink $apath)
    if [[ "$apath" =~ / ]]; then
        echo "$(_absdir $apath) ${apath##*/}"
    else
        echo "$(pwd -P) ${apath##*/}"
    fi
}
# _mklink src dstdir dstfile
_mklink(){
    [ "$link" ] || declare -gA link
    local src="$1";shift
    local dir="$1";shift
    local dst="$1";shift
    if [ -e $dir/$dst ] ; then
        if [ -h $dir/$dst ]; then
            [ "$src" = $(readlink $dir/$dst) ] && return 1
            echo $C3"Warning: link of $dir/$dst is different from $src"$C0
        else
            echo $C1"Error: $dir/$dst is regular file"$C0
            return 1
        fi
    fi
    user=$(stat -c %U $dir)
    sudo -u $user ln -sf $src $dir/$dst && link[$dir]+=" $dst"
}
_showlink(){
    for dir in ${!link[*]}; do
	echo "[${link[$dir]} ] -> $C1$dir$C0"
    done
    unset link
}
_binreg(){
    for i in *.sh *.pl *.py *.rb *.awk *.exp *.js; do
        [ -d "$i" -o ! -e "$i" -o -h "$i" -o ! -x "$i" ] && continue
        _mklink "$(pwd -P)/$i" "$HOME/bin" "${i%.*}"
    done
    _showlink
}
