#!/bin/bash
### Set func for human interface
# Generate alias by pick up '#alias XXX' line from each files
self_alias(){
    local head name par
    echo -n "Setting alias:"
    while read head al name par; do
        cmd="$al $name='$head${par:+ $par}'"
        dup=$($al $name > /dev/null 2>&1) || [ "$dup" == "$cmd" ] && continue
        eval $cmd && echo -n " $name"
    done < <(cd ~/bin; ( grep '^# *alias' * ; grep -h '(){ *# *alias' *) |tr '(){:#' ' ')
    echo
}
# Edit this file and update alias/func
edit_alias(){ #alias ea
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
edit_func(){ #alias ef
    local file=~/utils/bin/rc.bash.func.sh
    emacs $file
    source $file
}
# File registration
register_all(){ #alias reg
    file-register $*
    self_alias
}
# Grep alias/func
alias_grep(){ #alias ag
    alias|grep -i ${1:-.}
    set|egrep -v '^_'|egrep "^[-_a-zA-Z]+ \(\)"|grep -i ${1:-.}
}
# Grep env/var
env_grep(){ #alias eg
    (set;env)|egrep "^[-_a-zA-Z]+="|sort -u|grep -i ${1:-.}
}
# Grep process
ps_grep(){ #alias psg
    local exp="^UID${1:+|$1}"
    ps -ef | grep -v "$$ .* grep" | egrep -i "$exp"
}
# Switch user (alternative to su)
switch_user(){ #alias sb
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
