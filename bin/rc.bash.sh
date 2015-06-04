#!/bin/bash
# Recommended packages(Debian): byobu
# Description: setenv for login
umask 022
shopt -s nullglob
complete -r
# Set environment for login
# For PATH setting without duplication
addpath(){
    local key=$1;shift
    IFS=': '
    for j in $* ${!key}; do
        [ -d "$j" ] && [[ ! "$list" =~ (^|:)$j: ]] && list+="$j:"
    done
    unset IFS
    eval "export $key=${list%:}"
}
addpath PATH {~,/opt,/usr{/local,},}/{lib,sbin,bin}
# Other Environments
GREP_OPTIONS='--color=auto'
# PROMPT
PS1="\[\033[01;31m\][$SHLVL]\[\033[00m\]$PS1"
# SET Dist
os=$(info-os)
export DIST=${os#*/}
# Boot strap
shopt -s nullglob
for i in ~/bin/rc.bash.*;do
    source $i
done
