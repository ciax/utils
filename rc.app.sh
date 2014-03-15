#!/bin/bash
# Required packages: coreutils(cat,tty),diffutils(cmp)
# Description: provides query function
# Usage: _query
_query(){
    [ "$ALL" ] && return
    [ "$tty" ] || tty=`tty`
    echo -en "\tOK? $C3[A/Y/N/Q]$C0"
    read -e ans < $tty
    case "$ans" in
	[Aa]*)
            echo "All Accept!"
            ALL=1
            ;;
	[Yy]*)
            echo "Accept!"
            ;;
	[Qq]* )
            echo "Abort"
            exit 2
            ;;
	* )
            echo "Skip"
            return 1
            ;;
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
# Usage: overwrite [src_file] [dst_file]
_overwrite(){
    if cmp -s $1 $2 ; then
        /bin/rm $1;return 1
    else
        /bin/mv -b $1 $2
    fi
}
# Desctiption: Show usage if second arg is null.
#  (option and lists (input from file) are available.)
_usage(){
    [ "$2" ] && return
    echo "Usage: $C3${0##*/}$C0 ${1:-[option] \$n(=requred arg) <(list)}"
    [ -t 0 ] || while read i; do
	echo -e "\t$i"
    done
    exit 2
}
# Desctiption: Abort with message
# Usage: abort [message]
_abort(){ echo "$C1$*$C0";exit 1; }
