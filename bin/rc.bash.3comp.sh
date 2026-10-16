#!/usr/bin/env bash
set_comp(){
    # complete script commands
    cd ~/bin
    # making script option command list
    declare -A cmp
    while read a b c; do
	cmp[$a]="${cmp[$a]} $b"
    done < <(egrep -o '^ +[a-z]+\) *#' *|tr -d ")#:" )
    # set completion
    for i in ${!cmp[@]}; do
	complete -o default -o bashdefault -W "${cmp[$i]}" $i
    done
    cd
}
set_comp
