#!/bin/bash
# Required script: set.color.sh
# Required packages: coreutils(tty)
. set.color
[ "$ALL" ] && exit
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
