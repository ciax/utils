#!/bin/bash
# Description: grep recursive
#alias gr
[ "$1" ] || { echo "Usage: text-grep [regexp] (option) (files...)"; exit 1; }
# Remove lines below specified word per file
rm_below(){
    egrep -Hnm 1 -B 9999 "$1" $(egrep $ropt -l "$1")
    grep -Hn . $(egrep $ropt -L "$1")
}
while [[ "$1" == -* ]]; do
    opt="$opt $1"
    shift
done
ropt='-r --exclude-dir=.git'
reg="$1";shift
# Ignore case unless $reg contains upper case
[[ "$reg" =~ [A-Z] ]] || opt="$opt -i"
head='^.+[-:][0-9]+[-:]'
rm_below __FILE__ |
    # Exclude ^# line (actual line format:  filename:num:content
    egrep -v "$head *#" |
    egrep "$head.*$reg" |
    egrep --color $opt "$reg"
