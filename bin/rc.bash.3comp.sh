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
    complete -o bashdefault -o default -F _completion_loader -D
}
# For Redhat
set_default_comp(){
    _completion_loader ()
    {
	local compfile=./completions;
	[[ $BASH_SOURCE == */* ]] && compfile="${BASH_SOURCE%/*}/completions";
	compfile+="/${1##*/}";
	[[ -f "$compfile" ]] && . "$compfile" &>/dev/null && return 124;
	complete -o bashdefault -o default -F _minimal "$1" && return 124
    }
    complete -o bashdefault -o default -F _completion_loader -D
}
set_comp
[ -f /etc/redhat-release] && set_default_comp
