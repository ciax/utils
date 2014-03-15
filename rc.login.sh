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
export GREP_OPTIONS='-r --color=auto'
unset -f addenv

# PROMPT
PS1="\[\033[01;31m\][$SHLVL]\[\033[00m\]$PS1"

# Set alias for login

# Generate alias by pick up '#alias XXX' line from each files
while read head name par; do
    alias "$name=${head%:*}${par:+ $par}"
done < <(cd ~/bin;grep '^#alias' *)
[[ $0 == *login.alias* ]] && alias

# General Commands
alias update='upd-git;upd-db'
alias mo='more'
alias e='emacs -nw'
alias ls='ls -AF --color'
alias v='ls -l'
alias alg='alias|grep -i'
alias eng='env|grep -i'
alias seg='set|grep "^[a-zA-Z]"'
alias psg='ps -ef|grep -i'

# For GIT
alias gia='git add . */'
alias gib='git branch'
alias gic='git commit -v'
alias gid='git diff --color=always'
alias gil='git log --abbrev=4 --abbrev-commit --decorate --stat --graph --color'
alias gim='git merge'
alias gir='git checkout -f'
alias girr='git reset --hard HEAD~;git log -1|cat'
alias gis='git branch -a;git log -1|cat;git status'
alias giu='git checkout'

# Commands manupulating shell variables
e-rc(){
    file=rc.login.alias.sh
    pushd ~/utils >/dev/null
    unalias $(egrep '^alias' $file|cut -d ' ' -f2|cut -d '=' -f1|tr '\n' ' ')
    unset -f $(egrep '^[a-z]+' $file|cut -d '(' -f1|tr '\n' ' ')
    emacs $file
    git commit -m "update login script" $file
    source $file
    unset file
    popd >/dev/null
}
reg(){
    file-register
    source login.alias
}
gr(){
    grep -r $1 *
}
