#!/bin/bash
# Description: grep recursive
#alias gr
[ "$1" ] || { echo "Usage: text-grep (option) [regexp] (files...)"; exit 1; }
# Remove lines below specified word per file
rm_below(){
    sep=__FILE__
    target=${*:-'-r --exclude-dir=.git'}
    egrep -Hnm 1 -B 9999 $sep $(egrep -l $sep $target)
    grep -Hn . $(egrep -L $sep $target)
}
while [[ "$1" == -* ]]; do
    opt="$opt $1"
    shift
done
reg="$1";shift
# Ignore case unless $reg contains upper case
[[ "$reg" =~ [A-Z] ]] || opt="$opt -i"
head='^.+[-:][0-9]+[-:]'
rm_below $*|
    # Exclude ^# line (actual line format:  filename:num:content
    egrep -v "$head *#" |
    egrep $opt "$head.*$reg" |
    egrep --color $opt "$reg"
