#!/usr/bin/env bash
cd ~/bin
for i in *; do
    read a < <(egrep -o '^ +[a-z]+\) *#' $i|tr -d ")#\n")
    [ "$a" ] && complete -W "$a" $i
done

