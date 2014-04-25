#!/bin/bash
# Description: setenv for login
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
# For PATH
addpath(){
    local list="$1";shift
    for j; do
        [ -d "$j" ] || continue
        (IFS=:;for i in $list;do
            [ "$j" = "$i" ] && break
        done) || list+=":$j"
    done
    echo $list
}
export PATH=$(addpath $PATH {~,/usr{/local,},}/{bin,sbin,lib})
export RUBYLIB=$(addpath $RUBYLIB $HOME/lib)
unset -f addpath
# Other Environments
export GREP_OPTIONS='--color=auto'
# Set Distribution
set - $(</etc/issue)
export DIST="$1"

# PROMPT
PS1="\[\033[01;31m\][$SHLVL]\[\033[00m\]$PS1"

