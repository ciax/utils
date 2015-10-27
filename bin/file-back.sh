#!/bin/bash
#alias back
# Required scripts: func.getpar
# Description: restore backup file
. func.getpar
_usage "[file]"
if [ -e "$1~" ] ; then
    mv "$1~" $1
elif [ -e ~/.trash/$1 ]; then
    mv ~/.trash/$1 $1
else
    exit
fi
_warn "File $1 restored"
