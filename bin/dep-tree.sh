#!/bin/bash
#alias dep
# Description: show script dependency tree
core(){
    base="${1##*/}"
    echo "${base%.*}"
}
top_list(){
    while read top;do
        echo "$(core $top)"
    done < <(egrep -RL "$search" *|grep 'sh$')|sort
}
sub_list(){
    while read line;do
        local me="$(core ${line%%:*})"
        line="${line// /}"
        line="${line##*:}"
        for sup in ${line//,/ };do
            sub0[$sup]+=" $me"
        done
    done < <(egrep -R "$search" *)
}
dep_dig(){
    [ "${2:-0}" -gt  20 ] && _abort "Infinite Loop Error"
    for sb in ${sub0[$1]};do
        [ "${depth[$sb]:-0}" -le ${2:-0} ] || continue
        depth[$sb]=$2
        super[$sb]=$1
        dep_dig "$sb" $(($2+1))
    done
}
dep_stack(){
    for me in ${!super[*]};do
        local sup=${super[$me]}
        sub[$sup]+=" $me"
    done
}
show_tree(){
    [ "${#2}" -gt  100 ] && _abort "Infinite Loop Error"
    local subs="$(for i in ${sub[$1]};do echo " $i";done|sort)"
    local last="${subs##* }"
    local ind="$2   "
    for sb in $subs;do
        echo "$ind|--$C2$sb$C0"
        if [ "$sb" = "$last" ] ; then
            show_tree $sb "$ind "
        else
            show_tree $sb "$ind|"
        fi
    done
}
### main ###
declare -A sub0
declare -A sub
declare -A super
declare -A depth
cd ~/utils
search="^# Required scripts"
all=$(top_list)
sub_list
for top in $all;do
    dep_dig "$top"
done
dep_stack
for top in $all;do
    echo $C5"$top"$C0
    show_tree "$top"
done
