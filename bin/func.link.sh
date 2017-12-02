#!/bin/bash
# Description: make links of files
# if dst file exists -> dst=regular file:>fail , dst=org link:>skip
# Create or Overwrite unexist link
. ~/utils/bin/func.msg.sh
# declare -gA LINKS # for Bash 4 or later
_absdir(){ # Show Abs Dir
    local dir="${1%/*}"
    mkdir -p "$dir"
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
# _mklink srcfile dstfile
_mklink(){ # Make links with abspath
    local src="$1";shift
    eval "dst=$1";shift #dst could include '~'
    if [ -h $src ]; then
        _alert "Alert: $src is symbolic link"
        return 1
    elif [ -e $dst ] ; then
        if [ -h $dst ]; then
            if [ "$src" = $(readlink $dst) ]; then
                return 1
            else
                _warn "Warning: link of $dst is different from $src"
            fi
        elif [ -d $dst ] ; then
            _alert "Alert: $dst must not directory"
            return 1
        else
            mv $dst $dst.org
            _warn "Warning: Backup $dst with .org"
        fi
    fi
    local dir=$(_absdir $dst)
    local sud="sudo -u $(stat -c %U $dir)"
    $sud ln -sf $src $dst && _addlink $dir $(basename $dst)
}
_addlink(){
    eval "LINKS${1//[\/.]/_}+=' $2'"
    #LINKS[$1]+=" $2" # For Bash 4 or later
}
_showlink(){ # Show links created
    local dir links
    for links in ${!LINKS_*};do
        dir=${links#LINKS}
        echo "[${!links} ] -> $C1${dir//_/\/}$C0"
        unset $links
    done
    # For Bash 4 or later
    # for dir in ${!LINKS[*]}; do
    #     echo "[${LINKS[$dir]} ] -> $C1$dir$C0"
    # done
    # unset LINKS[*]
}
_linkbin(){ # Scripts register to ~/bin
    [ -d "$1" -o ! -e "$1" -o -h "$1" -o ! -x "$1" ] && return
    _mklink "$(pwd -P)/$1" "$HOME/bin/${1%.*}"
}
_setup_link(){ # Scripts register to ~/bin
    local i
    for i in *.sh *.pl *.py *.rb *.awk *.exp *.js; do
        _linkbin $i
    done
}
_chkfunc $*
