#!/bin/bash
# Description: show dependent scripts
core(){
    str=${1##*/}
    echo ${str%.*}
}
declare -A sub
while read line; do
    shared=$(core $line)
    for user in $(egrep -rl "$shared" *);do
#    for user in $(egrep -rl "^[^#].*$shared" *);do
        [[ $user == *.sh ]] || continue
        user=$(core $user)
        [ "$user" = "$shared" ] || sub[$shared]+=" $user"
    done
    echo "$shared > ${sub[$shared]}"
done < <(find ~/utils -name '*.sh') | sort
