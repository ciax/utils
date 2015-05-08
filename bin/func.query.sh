#!/bin/bash
# Description: query function
. func.msg
_al(){ # Alert
    echo -e "\t"$C1"$*"$C0
}
_hl(){ # Highlight
    echo -e "\t"$C2"$*"$C0
}
_query(){ # Interactive query
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
_func_list func.query
