#!/bin/bash
#alias dep
# Required scripts: func.getpar
# Description: show script dependency tree
top_list(){
    while read top;do
        top="${top##*/}"
        echo "${top%.*}"
    done < <(cd ~/utils;grep -RL "Required scripts" *|grep 'sh$')|sort
}
dep_list(){
    while read line;do
        local me="${line%%:*}"
        line="${line// /}"
        line="${line##*:}"
        for sup in ${line//,/ };do
            sub[$sup]="${sub[$sup]}$me "
        done
    done < <(cd ~/bin;egrep "^# Required scripts" *-*)
}
dep_dig(){
    for sb in ${sub[$1]};do
        [ "${depth[$sb]:-0}" -le ${2:-0} ] || continue
        depth[$sb]=$2
        super[$sb]=$1
        dep_dig "$sb" $(($2+1))
    done
}
dep_stack(){
    for me in ${!super[*]};do
        local sup=${super[$me]}
        sub2[$sup]="${sub2[$sup]}$me "
    done
}
show_tree(){
    [ "${#2}" -gt  100 ] && _abort "Infinite Loop Error"
    local ind="    |$2"
    while read sb;do
        echo "${ind}---$C2$sb$C0"
        show_tree $sb "$ind"
    done < <(for i in ${sub2[$1]};do echo "$i";done|sort)
}
### main ###
declare -A sub
declare -A sub2
declare -A super
declare -A depth

all=$(top_list)
dep_list
for top in $all;do
    dep_dig "$top"
done
dep_stack
for top in $all;do
    echo $C5"$top"$C0
    show_tree $top
done
