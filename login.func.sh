#!/bin/bash
# Description: commands manupulating shell variables
# Required Packages: emacs,most
e-alias(){
    file=login.alias.sh
    pushd ~/utils >/dev/null
    unalias $(egrep '^alias' $file|cut -d ' ' -f2|cut -d '=' -f1|tr '\n' ' ')
    emacs $file
    git commit -m "update alias" $file
    source $file
    unset file
    popd >/dev/null
}
e-func(){
    file=login.func.sh
    pushd ~/utils >/dev/null
    unset -f $(egrep '^[a-z]+' $file|cut -d '(' -f1|tr '\n' ' ')
    emacs $file
    git commit -m "update func" $file
    source $file
    unset file
    popd >/dev/null
}
reg(){
    file-register
    source login.alias
}
gr(){
    grep -r $1 *
}