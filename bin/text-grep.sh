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
# Exclude ^# line (actual line format:  filename:num:content
head='^.+-[0-9]+-'
egrep -rn --exclude-dir=.git -m 1 -B 9999 __FILE__ $* |
    egrep -v "$head *#" |
    egrep "$head.*$reg" |
    egrep --color $opt "$reg"
