#!/bin/bash
#alias e
# Required packages: emacs
# Required scripts: func.getpar
# Description: edit file with emacs as its owner
. func.getpar
_usage "[file]"
if [ -s "$1" ];then
    user=$(stat -c %U $1)
    cp -pub $1 ~/.trash/
else
    user=$LOGNAME
fi
sudo -u $user emacs -nw $*
