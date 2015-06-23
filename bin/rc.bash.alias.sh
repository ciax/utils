#!/bin/bash
### Set alias/func for human interface
# Generate alias by pick up '#alias XXX' line from each files
self-alias(){
    grep '^#alias' ~/bin/* > ~/.var/tempfile
    while read head name par; do
        eval "alias $name='${head%:*}${par:+ $par}'"
    done < ~/.var/tempfile
    rm ~/.var/tempfile
}
# Edit this file and update alias/func
ae(){
    file=rc.bash.alias.sh
    pushd ~/utils/bin >/dev/null
    unalias $(egrep '^alias' $file|cut -d ' ' -f2|cut -d '=' -f1|tr '\n' ' ')
    unset -f $(egrep '^[a-z]+' $file|cut -d '(' -f1|tr '\n' ' ')
    emacs $file
    source $file
    unset file
    popd >/dev/null
}
# File registration
reg(){
    file-register $*
    self-alias
}
# Grep recursive
gr(){
    [ "$1" ] || return
    if [[ "$1" =~ [A-Z] ]]; then
        grep -rn "$*" *
    else
        grep -irn "$*" *
    fi
}
# Switch user
sb(){
    sudo -s ${1:+-u $1}
}
# Search alias/func
ag(){
    alias|grep -i ${1:-.}
    set|egrep "^[-_a-zA-Z]+\(\)"|grep -i ${1:-.}
}
# Search env/var
eg(){
    (set;env)|egrep "^[-_a-zA-Z]+="|sort -u|grep -i ${1:-.}
}
# Search process
psg(){
    ps -ef|grep -i ${1:-.}
}

## Aliasing
# General Commands
alias update='git-update;db-update'
alias mo='more'
alias mroe='more'
alias ls='ls -AF --color'
alias v='ls -l'
alias kilg='sudo killall -i -I -r'
alias bogo='dmesg|grep Bogo'

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

self-alias
