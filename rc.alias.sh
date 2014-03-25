#!/bin/bash
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
alias ag='alias|grep -i'
alias eg='env|grep -i'
alias sg='set|grep "^[a-zA-Z]"'
alias psg='ps -ef|grep -i'
alias kilg='sudo killall -i -I -r'

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
e-alias(){
    file=rc.alias.sh
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
    source rc.alias
}
gr(){
    grep -r $1 *
}
