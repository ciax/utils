#!/bin/bash
# Required: od
# option (-n): no folding by return code but show (0a)
if [ -t 1 ] ; then
    C4=$'\e[1;34m'
    C0=$'\e[0m'
fi
[ "$1" = "-n" ] && shift || nl='0a'
[ -t 0 -a ! -e "$1" ] && { echo "Usage: visible (-n) [file]"; exit; }
for c in `od -v -A n -t x1 $1` ; do
    if [ "$c" = '0a' -a "$nl" ] ; then
        echo
    elif [ "$c" \< '20' -o "$c" \> '80' ] ; then
        echo -n "$C4($c)$C0"
    else
        echo -en "\x$c"
   fi
done
echo
