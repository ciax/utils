#!/bin/bash
# Recommended packages(Debian): byobu
# Description: setenv for login
umask 022
shopt -s nullglob
complete -r
# Set environment for login
# Remove duplicated env var
addpath(){
    for i ; do
        pushd $i >/dev/null 2>&1 && PATH=$PATH:$PWD && popd >/dev/null
    done
}
uniqenv(){
    local i j list
    for i; do
        list=$(IFS=:; for j in ${!i}; do echo $j;done|awk -v ORS=: '!x[$0]++')
        eval "$i=${list%:}"
    done
}
addpath {~,/opt,/usr{/local,},}/{lib,sbin,bin}
# Other Environments
export GREP_OPTIONS='--color=auto'
export VERSION_CONTROL=t
# PROMPT
i="\[\033[01;31m\][$SHLVL]\[\033[00m\]"
PS1=$i${PS1//"$i"/}
# SET Dist
i=$(info-os)
export DIST=${i#*/}
# Boot strap
for i in ~/bin/rc.bash.*;do . $i;done
uniqenv PATH RUBYLIB
unset i
