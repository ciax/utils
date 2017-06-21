#!/bin/bash
### Set alias for human interface
unalias -a
# General Commands
alias update='git-update;db-update'
alias mo='more'
alias mroe='more'
alias ls='ls -AF --color'
alias grep='--color=auto'
alias v='ls -l'
alias r='rubocop -a'
alias kilg='sudo killall -i -I -r'
alias bogo='grep bogomips /proc/cpuinfo'
alias ea=edit_alias
alias ef=edit_func
alias fmj='python -m json.tool'
alias fmx='xmllint --format'

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
# Update remote repo list
alias gip='git remote prune origin'

# For package admin
alias pks='pkg search'
alias pki='pkg install'
alias pku='pkg upd'
alias pkw='pkg where'
alias pkf='pkg files'
