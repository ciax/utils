#!/bin/bash
# Required scripts: func.getpar
# Description: edit file as its owner
. func.getopts
. func.sudo
_usage "[file] .."
cmd=$EDITOR
file="$1";shift
[ -h "$file" ] && file=$(readlink $file)
user=$(_fuser $file)
[ $LOGNAME != $user ] && cmd="_sudy -u $user $cmd"
$cmd "$file" $*
