#!/bin/bash
# Required scripts: func.color
# Show usage if second arg is null.
# (option and lists (input from file) are available.)
. ~/utils/func.color.sh
opt=${1:-"[option] \$n(requred arg) <(list)"}
if [ ! "$2" ]; then
    echo "Usage: $C3${0##*/}$C0 $opt"
    [ -t 0 ] || while read i; do
	echo -e "\t$i"
    done
    exit 2
fi
abort(){ color1 "$*";exit 1; }
