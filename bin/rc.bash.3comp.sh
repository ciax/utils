#!/usr/bin/env bash
set_comp(){
    cd ~/bin
    declare -A cmp
    while read a b c; do
	cmp[$a]="${cmp[$a]} $b"
    done < <(egrep -o '^ +[a-z]+\) *#' *|tr -d ")#:" )
    for i in ${!cmp[@]}; do
	complete -W "${cmp[$i]}" $i
    done
    cd
}
set_comp
