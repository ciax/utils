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
chkcmd less && export LESSCHARSET=utf-8
if chkcmd emacs; then
    export EDITOR='emacs -nw'
    export MOST_EDITOR='emacs %s -g %d'
fi
if chkcmd most; then
    export PAGER='most'
#elif chkcmd vim; then
#    export PAGER='vim -M'
#    export VISUAL='vim' # For ranger
else
    export PAGER='more'
fi
export GIT_EDITOR=$EDITOR # For Git
alias m=$PAGER
