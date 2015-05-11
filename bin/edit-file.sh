#!/bin/bash
#alias e
# Required packages: emacs
# Required scripts: func.getpar
# Description: edit file with emacs as its owner
. func.getpar
_usage "[file] (line) .."
args=''
for file;do
    if [ -s "$file" ];then
        user=$(stat -c %U $file)
        cp -pub $file ~/.trash/
        bkup-stash $file
    else
        user=$LOGNAME
    fi
    if [[ "$file" =~ ^[0-9]+$ ]] ; then
        args="+$file $args"
    else
        args="$file $args"
    fi
done
sudo -eu $user $args
