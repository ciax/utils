#!/bin/bash
# Description: provides query function
# Required packages: coreutils(tty)
query(){
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
