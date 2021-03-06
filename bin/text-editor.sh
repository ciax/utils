#!/bin/bash
# Required packages: emacs
# Required scripts: func.getpar
# Description: edit file with emacs as its owner
#alias e
. func.getpar
_usage "[file] (line) .."
args=''
for file;do
    if [ -s "$file" ];then
        [ -h "$file" ] && file=$(readlink $file)
        cp -pub $file ~/.trash/
        bkup-stash $file
    fi
    if [[ "$file" =~ ^[0-9]+$ ]] ; then
        args="+$file $args"
    else
        args="$file $args"
    fi
done
$(_setcmd edit-sudo "$EDITOR") $args
