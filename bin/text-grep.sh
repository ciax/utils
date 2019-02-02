#!/bin/bash
# Description: grep recursive and show before and after in splited by separator
#alias gr
# Remove lines below specified word per file
list(){
    egrep -$1 $SEP $target
}
split(){
    egrep -Hnm 1 -${1:0:1} 9999 $SEP $inc | egrep -v "$head#" |
        search > $temp && {
        echo "-------- $1 [$SEP] --------"
        form < $temp
    }
    rm $temp
}
search(){
    egrep $opt "$head.*$reg"
}
form(){
    sed -E "s/$head/\1:\2:\t/"|
        sort | expand -t 24 |
        egrep --color $opt "$reg"
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
head='^(.+)[-:]([0-9]+)[-:] *'
SEP=${SEP:-__FILE__}
target=${*:-'-r --exclude-dir=.git'}
temp=~/.var/.gtemp.txt
# File list that excludes $SEP
exc=$(list L) && egrep -Hnv '^ *#' $exc | search | form
# File list that includes $SEP
inc=$(list l) && { split Before; split After; }
