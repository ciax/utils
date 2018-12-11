#!/bin/bash
# Description: grep recursive
#alias gr
[ "$1" ] || exit
while [[ "$1" == -* ]]; do
    opt="$opt $1"
    shift
done
reg="$1";shift
[[ "$reg" =~ [A-Z] ]] || opt="$opt -i"
# Exclude ^# line (actual line format:  filename:num:contents)
egrep -rn $opt --exclude-dir=.git "$reg" $*|egrep -v '^.+:[0-9]+: *#'|egrep --color $opt "$reg"
