#!/bin/bash
#alias depb |dep-tree
# Description: show script dependency list
core(){
    base="${1##*/}"
    echo "${base%.*}"
}

for line in ${*:-*.sh}; do
    shared=$(core $line)
    echo "$shared"
    for user in $(grep -rl "$shared" *);do
        [[ $user == *.sh ]] || continue
        user=$(core $user)
        [ "$user" = "$shared" ] || echo "$shared $user"
    done
done
