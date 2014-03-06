#!/bin/bash
# Requied Packages: emacs,most
e-alias(){
    file=rc.alias.sh
    pushd ~/utils >/dev/null
    unalias $(egrep '^alias' $file|cut -d ' ' -f2|cut -d '=' -f1|tr '\n' ' ')
    emacs $file
    source $file
    git commit -m "update alias"
    unset file
    popd >/dev/null
}
e-func(){
    file=rc.func.sh
    pushd ~/utils >/dev/null
    unset -f $(egrep '^[a-z]+' $file|cut -d '(' -f1|tr '\n' ' ')
    emacs $file
    source $file
    git commit -m "update func"
    unset file
    popd >/dev/null
}
reg(){
    file-register
    source rc.alias
}
