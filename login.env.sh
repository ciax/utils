#!/bin/bash
# Description: set environment for login
# Requied Packages: emacs,most
addenv(){
    local name=$1;shift
    local list=$(IFS=: eval echo \$$name)
    for j ; do
        for i in $list;do
            [ "$j" = "$i" ] && break 2
        done
        eval "export $name=$j:\$$name"
    done
}

# Local functions
umask 022
shopt -s nullglob
addenv PATH "$HOME/bin" "$HOME/lib"
addenv RUBYLIB "$HOME/lib"
export EDITOR='emacs'
export PAGER='most'
export MOST_EDITOR='emacs %s -g %d'
export GREP_OPTIONS='-r --color=auto'
unset -f addenv

# ETC
PS1="[$SHLVL]$PS1"