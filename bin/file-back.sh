#!/bin/bash
#alias back
# Required scripts: func.getpar
# Description: restore backup file
. func.getpar
_usage "[file]"
if [ -e "$1~" ] ; then
    sudo /bin/mv "$1~" $1
elif [ -e ~/.trash/$1 ]; then
    sudo /bin/mv ~/.trash/$1 $1
else
    exit
fi
echo $C3"File $1 restored"$C0