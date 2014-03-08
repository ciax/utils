#!/bin/bash
# Description: display invisible chars in files
# Required scripts: func.usage
# Required packages: coreutils(od)
#  option (-n): no folding by return code but show (0a)
[ "$1" = "-n" ] && shift || nl='0a'
[ -t 0 -a ! -e "$1" ] && . func.usage "(-n) [file]"
for c in `od -v -A n -t x1 $1` ; do
    if [ "$c" = '0a' -a "$nl" ] ; then
        echo
    elif [ "$c" = '09' -a "$nl" ] ; then
        echo -en "$C3>$C0\t"
    elif [ "$c" \< '20' -o "$c" \> '80' ] ; then
        echo -n "$C4($c)$C0"
        unset nl
    else
        echo -en "\x$c"
   fi
done
echo
