#!/bin/bash
### Set func for human interface
# Generate alias by pick up '#alias XXX' line from each files
self-alias(){
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
edit-alias(){
    local file=rc.bash.alias.sh
    pushd ~/utils/bin >/dev/null
    unalias $(egrep '^alias' $file|cut -d ' ' -f2|cut -d '=' -f1|tr '\n' ' ')
    unset -f $(egrep '^[a-z]+' $file|cut -d '(' -f1|tr '\n' ' ')
    emacs $file
    source $file
    unset file
    popd >/dev/null
}
# Edit functions
edit-func(){
    local file=rc.bash.func.sh
    emacs $file
    source $file
}
# File registration
reg(){
    file-register $*
    self-alias
}
# Grep recursive for ruby
gr(){
    [ "$1" ] || return
    local reg="$1"
    [[ "$reg" =~ [A-Z] ]] || opt=-i
    shift
    local files="${*:-*.rb}"
    egrep -vrn "^ *#" ${files:-*} |egrep $opt ":.*($reg)"|egrep --color $opt "$reg"
}
# Switch user
sb(){
    sudo -s ${1:+-u $1}
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
self-alias >/dev/null
