#!/usr/bin/env bash
pushd ~/bin
for i in *; do
    read a < <(egrep -o '^ +[a-z]+\) *#' $i|tr -d ")#\n")
    [ "$a" ] && complete -W "$a" $i
done
popd
