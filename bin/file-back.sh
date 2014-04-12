#!/bin/bash
#alias back
# Required scripts: func.getpar
# Description: restore backup file
. func.getpar
_usage "[file]"
[ -e ~/.trash/$1 ] || exit
/bin/mv ~/.trash/$1 $1
echo $C3"File $1 restored"$C0