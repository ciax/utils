#!/bin/bash
# Required packages: coreutils(cat,tty),diffutils(cmp)
# Description: provides query function
ARGV="$*"
shopt -s nullglob
# Description: interactive query
# Usage: _query
_query(){
    [ "$ALL" ] && return
    [ "$tty" ] || tty=`tty`
    echo -en "\tOK? $C3[A/Y/N/Q]$C0"
    read -e ans < $tty
    case "$ans" in
        [Aa]*) echo "All Accept!";ALL=1;;
        [Yy]*) echo "Accept!";;
        [Qq]*) echo "Abort";exit 2;;
        * ) echo "Skip";return 1;;
    esac
}
# Desctiption: makes temporaly files
# Usage: _temp [varname1] [varname2] ..
_temp(){
    local trp="/bin/rm -f -- "
    local i=
    for i ; do
        local tmp=$(tempfile) || { echo "Can't make mktemp"; exit 1; }
        _tmplist="$_tmplist $tmp"
        eval "$i=$tmp"
    done
    trap "$trp$tmplist" EXIT
}
# Description: Overwrite if these are different.
# Usage: _overwrite [src_file] [dst_file]
_overwrite(){
    if cmp -s $1 $2 ; then
        /bin/rm $1;return 1
    else
        /bin/mv -b $1 $2
    fi
}
# Desctiption: Abort with message
# Usage: _abort [message]
_abort(){ echo "$C1$*$C0";exit 1; }
# Description: Show progress
# Usage: _progress [Title]
_progress(){
    if [ "$_prg_title" = "$1" ]; then
        echo -n '.'
    else
        echo -n "$1 "
        _prg_title="$1"
    fi
}
# Desctiption: Check argument
#  1.Check single options. opt-?() function should be provided.
#  2.Check argument by lists input from file.
# Usage: _chkarg < (option list); set - $ARGV
_chkarg(){
    set - "$ARGV"
    while [[ "$1" == -* ]];do
        if type -t opt$1 &>/dev/null;then
            opt$1;shift
        else
            echo $C1"No such option ($1)"$C0
            unset ARGV
            return 1
        fi
    done
    ARGV="$*"
    if [ ! -t 0 ];then
        while read i ;do
            for j in $i;do
                [ "$1" = "$j" ] && return
            done
            _usg_list="$_usg_list\t$i\n"
        done
        [ "$1" ] && echo $C1"Invalid argument ($1)"$C0
        unset ARGV
        return 1
    fi
}
# Desctiption: Show usage if second arg is null.
#  (option lists in $_usg_list are available.)
_usage(){
    if [ "$2" ] ; then
        unset _usg_list
    else
        echo -e "Usage: $C3${0##*/}$C0 ${1:-[option] \$n(=requred arg) <(list)}"
        [ "$_usg_list" ] && echo -en "$_usg_list"
        exit 2
    fi
}
