#!/bin/bash
#alias dep
# Required scripts: func.getpar
# Description: show script dependency tree
dep_list(){
    while read line;do
        me="${line%%:*}"
        line="${line// /}"
        line="${line##*:}"
        for sup in ${line//,/ };do
            [[ "${sub[$sup]}" =~ "$me" ]] || sub[$sup]="${sub[$sup]}$me "
        done
    done < <(egrep "^# Required scripts" *-*)
}
dep_dig(){
    for i in ${sub[$1]};do
        if [ "${depth[$i]:-0}" -lt $2 ];then
            depth[$i]=$2
            old=${super[$i]}
            [ "$old" ] &&  sub[$old]="${sub[$old]//$i/}"
            super[$i]=$1
            dep_dig "$i" $(($2+1))
        fi
    done
}
show_tree(){
    [ "${#2}" -gt  100 ] && _abort "Infinite Loop Error"
    local ind="    |$2"
    for i in ${sub[$1]};do
        echo "${ind}---$C2$i$C0"
        show_tree $i "$ind"
    done
}
### main ###
cd ~/bin
declare -A sub
declare -A super
declare -A depth

dep_list
cd ~/utils
while read top;do
    dep_dig "${top%.*}" 1
    all="$all ${top%.*}"
done < <(grep -RL "Required scripts" *.sh)
for top in $all;do
    echo $C5"$top"$C0
    show_tree $top
done
