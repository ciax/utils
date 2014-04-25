#!/bin/bash
# Description: make links of files
# if dst file exists -> dst=regular file:>fail , dst=org link:>skip
# Create or Overwrite unexist link
_abspath(){ # absdir filename
    eval "local apath=$1"
    [ -h "$apath" ] && apath=$(readlink $apath)
    if [[ "$apath" =~ / ]]; then
        echo "$(cd ${apath%/*};pwd -P) ${apath##*/}"
    else
        echo "$(pwd -P) ${apath##*/}"
    fi
}
_mklink(){
    local src="$1";shift
    local dst="$1";shift
    if [ -e $dst ] ; then
        if [ -h $dst ]; then
            [ "$src" = $(readlink $dst) ] && return 1
            echo $C3"Warning: link of $dst is different from $src"$C0
        else
            echo $C1"Error: $dst is regular file"$C0
            return 1
        fi
    fi
    ln -sf $src $dst && link+=" ${dst##*/}"
}
_showlink(){
    [ "$link" ] && echo "[$link ] -> $C1${1:-~/bin}$C0"
}
_binreg(){
    link=
    for i in *.sh *.pl *.py *.rb *.awk *.exp *.js; do
        [ -d "$i" -o ! -e "$i" -o -h "$i" -o ! -x "$i" ] && continue
        _mklink "$(pwd -P)/$i" "$HOME/bin/${i%.*}"
    done
    _showlink
}
shopt -s nullglob
[ -d "$HOME/bin" ] || mkdir "$HOME/bin"
_binreg
