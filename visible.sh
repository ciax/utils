#!/bin/bash
# Require script: set.color.sh, set.usage.sh
# Required: od
# option (-n): no folding by return code but show (0a)
. set.color
[ "$1" = "-n" ] && shift || nl='0a'
[ -t 0 -a ! -e "$1" ] && . set.usage "(-n) [file]"
for c in `od -v -A n -t x1 $1` ; do
    if [ "$c" = '0a' -a "$nl" ] ; then
        echo
    elif [ "$c" \< '20' -o "$c" \> '80' ] ; then
        echo -n "$C4($c)$C0"
        unset nl
    else
        echo -en "\x$c"
   fi
done
echo
