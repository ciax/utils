#!/bin/bash
# Description: grep recursive
#alias gr
local opt;
[ "$1" ] || return
while [[ "$1" == -* ]]; do
    opt="$opt $1"
    shift
done
local reg="$1";shift
[[ "$reg" =~ [A-Z] ]] || opt="$opt -i"
egrep -rn $opt --exclude-dir=.git "$reg"|egrep -v '^.+:[0-9]+: *#'|egrep --color $opt "$reg"
