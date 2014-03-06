#!/bin/bash
# Required script: func.color
. func.color
opt=${1:-"[option] \$n(requred arg)"}
if [ ! "$2" ]; then
    echo "Usage: $C3${0##*/}$C0 $opt"
    [ -t 0 ] || while read i; do
	echo -e "\t$i"
    done
    exit 2
fi
