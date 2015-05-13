#!/bin/bash
# Description: make links of files
# if dst file exists -> dst=regular file:>fail , dst=org link:>skip
# Create or Overwrite unexist link
. ~/utils/bin/func.msg.sh
declare -gA LINKS
_absdir(){ # Show Abs Dir
    local dir="${1%/*}"
    [ -d "$dir" ] || mkdir -p "$dir"
    cd "$dir";pwd -P
}
_abspath(){ # Show Abs file path
    eval "local apath=$1"
    [ -h "$apath" ] && apath=$(readlink $apath)
    if [[ "$apath" =~ / ]]; then
        echo "$(_absdir $apath) ${apath##*/}"
    else
        echo "$(pwd -P) ${apath##*/}"
    fi
}
# _mklink src dstdir dstfile
_mklink(){ # Make links with abspath
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
    local user=$(stat -c %U $dir)
    sudo -u $user ln -sf $src $dir/$dst && LINKS[$dir]+=" $dst"
}
_showlink(){ # Show links created
    local dir
    for dir in ${!LINKS[*]}; do
        echo "[${LINKS[$dir]} ] -> $C1$dir$C0"
    done
    unset LINKS[*]
}
_setup(){ # Scripts register to ~/bin
    local i
    for i in *.sh *.pl *.py *.rb *.awk *.exp *.js; do
        [ -d "$i" -o ! -e "$i" -o -h "$i" -o ! -x "$i" ] && continue
        _mklink "$(pwd -P)/$i" "$HOME/bin" "${i%.*}"
    done
}
_chkfunc $*
