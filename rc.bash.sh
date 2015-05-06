#!/bin/bash
# Recommended packages(Debian): byobu
# Description: setenv for login
umask 022
shopt -s nullglob
complete -r
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
os=$(info-os)
export DIST=${os#*/}
