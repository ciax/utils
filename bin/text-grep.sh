#!/bin/bash
# Description: grep recursive and show before and after in splited by separator
#alias gr
. func.file
list(){
    egrep -$1 "$SEP" $target
}
output(){
    sort < $temp | expand -t 24 | egrep --color $opt "$reg"
    rm $temp
}
search(){
    egrep $opt "$head.*$reg" | sed -E "s/$head/\1\t/" >> $temp
}
whole_search(){
    # note that grep -L returns 0 when there are matched files regardless output
    local exc=$(list L)
    [ "$exc" ] || return
    egrep -Hnv '^ *#' $exc | search
}
part(){
    egrep -Hnm 1 -$1 9999 "$SEP" $inc |
    sed -E "s/^(.+)[-:]([0-9]+)[-:]/\1:\2:/"|
    egrep -v "$head#" | search
}
part_search(){
    local inc=$(list l) || return
    part B
    output
    part A
    [ -s $temp ] && echo "-------- After [$SEP] --------"
}
# Main
[ "$1" ] || { echo "Usage:(SEP=?) text-grep (option) [regexp] (files...)"; exit 1; }
while [[ "$1" == -* ]]; do
    opt="$opt $1"
    shift
done
reg="$1";shift
# Ignore case unless $reg contains upper case
[[ "$reg" =~ [A-Z] ]] || opt="$opt -i"
head='^(.+:[0-9]+:) *'
SEP="${SEP:-__FILE__}"
target=${*:-'-r --exclude-dir=.git'}
_temp temp
whole_search
part_search
output
