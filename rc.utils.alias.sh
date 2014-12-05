#!/bin/bash
# Set alias for login

# General Commands
alias update='git-update;db-update'
alias mo='more'
alias ls='ls -AF --color'
alias v='ls -l'
alias ag='alias|grep -i'
alias eg='env|grep -i'
alias sg='set|grep "^[a-zA-Z]"'
alias psg='ps -ef|grep -i'
alias kilg='sudo killall -i -I -r'
alias sb='sudo bash'

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

# For package admin
alias pks='pkg search'
alias pki='pkg install'
alias pku='pkg upd'
alias pkw='pkg where'
alias pkf='pkg files'

# Commands manupulating shell variables
e-alias(){
    file=rc.utils.alias.sh
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
    file-linkbin $(git-dirs) $*
    file-linkcfg ~/cfg.*
    source rc.utils.alias
    file-clean ~/bin
}
gr(){
    [ "$1" ] || return
    if [[ "$1" =~ [A-Z] ]]; then
        grep -rn "$*" *
    else
        grep -irn "$*" *
    fi
}
