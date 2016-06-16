#!/bin/bash
### Set func for human interface
# Generate alias by pick up '#alias XXX' line from each files
self_alias(){
    local head name par
    grep '^#alias' ~/bin/* > ~/.var/tempfile
    echo -n "Setting alias:"
    while read head name par; do
        cmd="alias $name='${head%:*}${par:+ $par}'"
        dup=$(alias $name > /dev/null 2>&1) || [ "$dup" == "$cmd" ] && continue
        eval $cmd && echo -n " $name"
    done < ~/.var/tempfile
    rm ~/.var/tempfile
    echo
}
# Edit this file and update alias/func
edit_alias(){
    local file=~/utils/bin/rc.bash.alias.sh
    pushd ~/utils/bin >/dev/null
    unalias $(egrep '^alias' $file|cut -d ' ' -f2|cut -d '=' -f1|tr '\n' ' ')
    unset -f $(egrep '^[a-z]+' $file|cut -d '(' -f1|tr '\n' ' ')
    emacs $file
    source $file
    unset file
    popd >/dev/null
    self_alias
}
alias ea=edit_alias
# Edit functions
edit_func(){
    local file=~/utils/bin/rc.bash.func.sh
    emacs $file
    source $file
}
alias ef=edit_func
# File registration
reg(){
    file-register $*
    self_alias
}
# Grep recursive for ruby
gr(){
    local opt;
    [ "$1" ] || return
    while [[ "$1" == -* ]]; do
        opt="$opt $1"
        shift
    done
    local reg="$1";shift
    [[ "$reg" =~ [A-Z] ]] || opt="$opt -i"
    local files="${*:-*.rb}"
    egrep -vrn "^ *#" ${files:-*} |egrep $opt ":.*($reg)"|egrep --color $opt "$reg"
}
# Search alias/func
ag(){
    alias|grep -i ${1:-.}
    set|egrep -v '^_'|egrep "^[-_a-zA-Z]+ \(\)"|grep -i ${1:-.}
}
# Search env/var
eg(){
    (set;env)|egrep "^[-_a-zA-Z]+="|sort -u|grep -i ${1:-.}
}
# Search process
psg(){
    local cmd="grep -i ${1:-.}"
    ps -ef|$cmd|grep -v "$cmd"
}
# Switch user
sb(){
    sudo -i ${1:+-u $1}
}
# Switch user by name (GID = 100)
user_alias(){
    for l in $(cut -d: -f1,4 /etc/passwd|grep ':100$'); do
        i=${l%:*}
        alias $i="sudo -iu $i"
    done
}
self_alias >/dev/null
user_alias >/dev/null
