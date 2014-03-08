#!/bin/bash
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
