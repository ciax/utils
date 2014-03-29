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
# Description: 5 col folding list
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

# Desctiption: Check argument
# Check argument by lists input from file.
# Usage: _chkarg (option list)
_chkarg(){
    # In the list? (ARGV check)
    _valid_list=$*
    [ "$_valid_list" -a "$ARGV" ] || return 0
    set - $ARGV
    [[ " $_valid_list " =~ " $1 " ]] && return # exact match
    [ "$1" ] && echo $C1"Invalid argument ($1)"$C0
    ARGERR=1
    return 1
}
# Desctiption: Show usage if second arg is null.
#  1.Check single options. opt-?() function should be provided.
#  (option lists in $_valid_list are available.)
_usage(){
    # Option handling
    for i in $OPT;do
        if type -t opt$i &>/dev/null;then
            opt$i
        else
            echo $C1"No such option ($i)"$C0
            ARGERR=1
        fi
    done
    local parv=$* parc=$#
    [ "$ARGC" -lt "$parc" ] && ARGERR=1
    if [ "$ARGERR" ]; then
        echo -e "Usage: $C3${0##*/}$C0 $parv"
        _fold_list $_valid_list
        exit 2
    else
        unset _valid_list
    fi
}
# Option Separator
while [[ "$1" == -* ]];do
    OPT="$OPT $1";shift
done
ARGV=$*;ARGC=$#
