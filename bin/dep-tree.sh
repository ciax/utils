#!/bin/bash
#alias dep
# Description: show script dependency tree
core(){
    base="${1##*/}"
    echo "${base%.*}"
}
make_list(){
    while read line; do
        shared=$(core $line)
        for user in $(grep -rl "$shared" *);do
            [[ $user == *.sh ]] || continue
            user=$(core $user)
            [ "$user" = "$shared" ] || sub0[$shared]+=" $user"
        done
    done < <(find ~/utils -name '*.sh')
    all="${!sub0[*]}"
}
dep_dig(){
    [ "${2:-0}" -gt  20 ] && _abort "Infinite Loop Error"
    for sb in ${sub0[$1]};do
        [ "${depth[$sb]:-0}" -le ${2:-0} ] || continue
        depth[$sb]=$2
        super[$sb]=$1
        all=${all// $sb/}
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
make_list
for top in $all;do
    dep_dig "$top"
done
dep_stack
for top in $all;do
    echo $C5"$top"$C0
    show_tree "$top"
done
