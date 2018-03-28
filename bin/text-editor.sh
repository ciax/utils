#!/bin/bash
# Required packages: emacs
# Required scripts: func.getpar
# Description: edit file with emacs as its owner
#alias e
. func.getpar
_usage "[file] (line) .."
args=''
cmd=$EDITOR
for file;do
    if [ -s "$file" ];then
        [ -h "$file" ] && file=$(readlink $file)
        user=$(stat -c %U $file)
        cp -pub $file ~/.trash/
        bkup-stash $file
        [ $LOGNAME != $user ] && cmd="sudo -u $user $cmd"
        args="$file $args"
    elif [[ "$file" =~ ^[0-9]+$ ]] ; then
        args="+$file $args"
    fi
done
$cmd $args
echo "$cmd $args"
