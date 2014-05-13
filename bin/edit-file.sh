#!/bin/bash
#alias e
# Required packages: emacs
# Required scripts: func.getpar
# Description: edit file with emacs as its owner
. func.getpar
_usage "[file(:line)]"
args=''
for arg;do
    read file line <<< "${arg//:/ }"
    if [ -s "$file" ];then
        user=$(stat -c %U $file)
        cp -pub $file ~/.trash/
    else
        user=$LOGNAME
    fi
    [ "$line" ] && args+=" +$line"
    args+=" $file"
done
sudo -u $user emacs -nw $args
