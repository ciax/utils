#!/bin/bash
#link ~/.bash_completion
# Required Packages: emacs,most
# Description: initial login script loader
umask 022
shopt -s nullglob
complete -r
# Coloring for login
#  ESC[(A);(B)(C)m # A: 0=dark 1=light # B: 3=FG 4=BG # C: 1=R 2=G 4=B
#  environment variable "C?" are provided
if [ -t 2 ] ; then
    for i in 1 2 3 4 5 6 7 ; do
        eval "export C${i}=\$'\\e[1;3${i}m'"
    done
    export C0=$'\e[0m'
fi
# Set environment for login
# Required Packages: emacs,most
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
addenv PATH "$HOME/bin" "$HOME/lib"
addenv RUBYLIB "$HOME/lib"
export EDITOR='emacs'
export PAGER='most'
export MOST_EDITOR='emacs %s -g %d'
export GREP_OPTIONS='--color=auto'
unset -f addenv

# PROMPT
PS1="\[\033[01;31m\][$SHLVL]\[\033[00m\]$PS1"

source ~/utils/rc.alias.sh
