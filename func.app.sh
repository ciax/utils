#!/bin/bash
# Required packages: coreutils(cat,tty),diffutils(cmp)
# Description: provides query function
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

# Description: folding list (5 column)
# Usage: _fold_list [str] ...
_fold_list(){
    local c=0
    for i ;do
        c=$(( $c + 1))
        case $c in
            1) echo -en "\t$i";;
            5) echo "  $i";c=0;;
            *) echo -n "  $i";;
        esac
    done
    [ $c = 0 ] || echo
}
# Descripton: subroutine of _usage
_chkopt(){
    # Option handling
    #  option can take par with '=' (-x=par)
    for i in $OPT;do
        set - ${i//=/ }
        if type -t opt$1 &>/dev/null;then
            opt$*
        else
            echo $C1"Invalid option ($i)"$C0
            return 1
        fi
    done
}
_chkarg(){
    local par="$1";shift
    local valids=$*
    # Check the number of argument
    local num="$(IFS=[;set - $par;echo $(($#-1)))"
    [ "$ARGC" -lt "$num" ] && { echo $C1"Short Argument"$C0; return 1; }
    # Matching to the list
    [ "$valids" ] || return 0
    set - $ARGV
    [[ " $valids " =~ " $1 " ]] && return 0 # exact match
    [ "$1" ] && echo $C1"Invalid argument ($1)"$C0
    return 1
}
# Desctiption: Show usage and exec func as options
#   1. Check the number of arguments (ARGC >= $# ?)
#   2. Check the single options. opt-?() function should be provided.
# Argument format: 
#   mandatory must be enclosed by "[]"
#   optional is enclosed by "()"
#   (arg lists in $valids are available.)
# Usage: _usage [string] (valid list)
_usage(){
    # Show usage
    _chkopt && _chkarg "$@" && return 0
    echo -e "Usage: $C3${0##*/}$C0 $1";shift
    _fold_list $*
    exit 2
}

# Option Separator
while [[ "$1" == -* ]];do
    OPT="$OPT $1";shift
done
ARGV=$*;ARGC=$#
