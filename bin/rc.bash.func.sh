#!/bin/bash
### Set func for human interface
# Generate alias by pick up '#alias XXX' line from each files
self_alias(){
    local head name par tempfile=~/.var/cache/tempfile
    grep '^#alias' ~/bin/* > $tempfile
    echo -n "Setting alias:"
    while read head name par; do
        cmd="alias $name='${head%:*}${par:+ $par}'"
        dup=$(alias $name > /dev/null 2>&1) || [ "$dup" == "$cmd" ] && continue
        eval $cmd && echo -n " $name"
    done < $tempfile
    rm -f $tempfile
    echo
}
# Edit this file and update alias/func
alias ea='edit_alias'
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
# Edit functions
alias ef='edit_func'
edit_func(){
    local file=~/utils/bin/rc.bash.func.sh
    emacs $file
    source $file
}
# File registration
alias reg='register_all'
register_all(){
    file-register $*
    self_alias
}
# Grep alias/func
alias ag='alias_grep'
alias_grep(){
    alias|grep -i ${1:-.}
    set|egrep -v '^_'|egrep "^[-_a-zA-Z]+ \(\)"|grep -i ${1:-.}
}
# Grep env/var
alias eg='env_grep'
env_grep(){
    (set;env)|egrep "^[-_a-zA-Z]+="|sort -u|grep -i ${1:-.}
}
# Grep process
alias psg='ps_grep'
ps_grep(){
    local exp="^UID${1:+|$1}"
    ps -ef | grep -v "$$ .* grep" | egrep -i "$exp"
}
# Switch user (alternative to su)
alias sb='switch_user'
switch_user(){
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
