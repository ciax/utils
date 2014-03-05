#!/bin/bash
# Requied Packages: emacs,most
e-alias (){
    file=rc.alias.sh;
    pushd ~/utils;
    unalias -a;
    emacs $file;
    source $file;
    git commit -m "update alias";
    unset file;
    popd
}
e-func(){
    file=rc.func.sh;
    pushd ~/utils;
    for i in `egrep -o "^[a-z]+" $file`;
    do
        unset $i;
    done;
    emacs $file;
    source $file;
    git commit -m "update func";
    unset file i;
    popd
}
