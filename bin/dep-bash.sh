#!/bin/bash
#alias depb |dep-tree
# Description: show script dependency list
core(){
    base="${1##*/}"
    echo "${base%.*}"
}

for line in ${*:-*.sh}; do
    shared=$(core $line)
    for user in $(grep -rl "\b$shared\b" *);do
        [[ $user == *.sh ]] || continue
        user=$(core $user)
        [ "$user" = "$shared" ] || echo "$shared $user"
    done
done
