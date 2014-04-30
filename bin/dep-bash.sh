#!/bin/bash
# Description: show script dependency list
core(){
    base="${1##*/}"
    echo "${base%.*}"
}

while read line; do
    shared=$(core $line)
    echo "$shared"
    for user in $(grep -rl "$shared" *);do
        [[ $user == *.sh ]] || continue
        user=$(core $user)
        [ "$user" = "$shared" ] || echo "$shared $user"
    done
done < <(find "${1:-.}" -name '*.sh'|sort)
