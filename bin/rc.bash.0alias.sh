#!/bin/bash
## Check Command
chkcmd(){
    type $1 >/dev/null 2>&1
}
### Set alias for human interface
unalias -a
# General Commands
alias update='git-pullall;db-update'
alias updev='dl-db device;cfg-hosts -s;ssh-config -s'
alias mo='more'
alias mroe='more'
alias ls='ls -AF --color'
alias grep='grep --color=auto'
alias v='ls -l'
alias r='rubocop -a'
alias bogo='grep bogomips /proc/cpuinfo'
alias dum='du -csxhL */'
alias fmj='python -m json.tool'
alias fmx='xmllint --format'
alias reload='. ~/.bashrc'


# For GIT
chkcmd git && {
    alias gia='git add . */'
    alias gib='git branch'
    alias gic='git commit -v'
    alias gid='git diff --color=always'
    alias gil='git log --abbrev=4 --abbrev-commit --decorate --stat --graph --color'
    alias gim='git-merge'
    alias gir='git checkout -f'
    alias girr='git reset --hard HEAD~;git log -1|cat'
    alias gis='git branch -a;git log -1|cat;git status'
    alias giu='git checkout'
    # Update remote repo list
    alias gip='git remote prune origin;git remote show origin'
}
# For Mercurial
chkcmd hg && {
    alias hgi="hg init;hg commit -A -m 'initial'"
    alias hgh="hg heads -v"
    alias hgs="hg st"
    alias hgp="hg push"
    alias hgr="hg revert"
    alias hgrr="hg rollback"
    alias hgl="hg log -l3 -v"
    alias hgd="hg diff"
    alias hgu="hg pull;hg upd -C && init-bin *"
    alias hgc="hg pull;hg upd;hg commit -A;hg push"
    alias hgm="hg merge;hg commit -m 'merge';hg push"
}

# For package admin
alias pks='pkg search'
alias pkw='pkg where'
alias pkf='pkg files'

# File Rename
alias renrb='text-replace -e=rb'
alias rensh='text-replace -e=sh'
