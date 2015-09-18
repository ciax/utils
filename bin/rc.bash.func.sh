#!/bin/bash
### Set func for human interface
# Generate alias by pick up '#alias XXX' line from each files
self-alias(){
    local head name par
    grep '^#alias' ~/bin/* > ~/.var/tempfile
    while read head name par; do
        eval "alias $name='${head%:*}${par:+ $par}'"
    done < ~/.var/tempfile
    rm ~/.var/tempfile
}
# Edit this file and update alias/func
ae(){
    local file=rc.bash.alias.sh
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
    local cmd="grep -i ${1:-.}"
    ps -ef|$cmd|grep -v "$cmd"
}
self-alias
