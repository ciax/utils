#!/bin/bash
# Recommended packages(Debian): byobu
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
    C0=$'\e[0m'
fi
# Set environment for login
# For PATH setting without duplication
addpath(){
    IFS=": "
    for j; do
        [ -d "$j" ] || continue
	[[ "$list" =~ :$j[:$] ]] && continue
	list+=":$j"
    done
    echo "${list#:}"
}
PATH=$(addpath {~,/opt,/usr{/local,},}/{lib,sbin,bin} $PATH)
unset -f addpath
# Other Environments
GREP_OPTIONS='--color=auto'
# PROMPT
PS1="\[\033[01;31m\][$SHLVL]\[\033[00m\]$PS1"
# SET Dist
info-os
os=$(info-os)
export DIST=${os#*/}
