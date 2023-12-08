#!/bin/bash
# Environment Setting
# Initialize functions
addpath(){
    for i ; do
        pushd $i >/dev/null 2>&1 && PATH=$PATH:$PWD && popd >/dev/null
    done
}
# Description: setenv for login
umask 022
# Set environment for login
# Remove duplicated env var
addpath {~,/opt,/usr{/local,},}/{lib,sbin,bin}

# PROMPT
i="\[\033[01;31m\][$SHLVL]\[\033[00m\]"
PS1=$i${PS1//"$i"/}

# SET Dist
i=$(info-os)
export DIST=${i#*/}

# Other Environments
export VERSION_CONTROL=t

# Editor Setting
chkcmd emacs && export EDITOR='emacs -nw'
chkcmd most && export PAGER='most'
chkcmd emacs && export MOST_EDITOR='emacs %s -g %d'
chkcmd less && export LESSCHARSET=utf-8
export VISUAL=$PAGER # For ranger
export GIT_EDITOR=$EDITOR # For Git
