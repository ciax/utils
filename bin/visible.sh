#!/bin/bash
# Required scripts: func.getpar
# Description: display invisible chars in files
#  option (-n): no folding by return code but show (0a)
. func.getpar
nl='0a'
opt-n(){ nl=; } #no fold
_usage "<file>"
_exe_opt
for c in $(od -v -A n -t x1 $*) ; do
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
