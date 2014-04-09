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
                [[ "${super[$me]}" =~ "$sup" ]] || super[$me]="${super[$me]}$sup "
                [[ "${sub[$sup]}" =~ "$me" ]] || sub[$sup]="${sub[$sup]}$me "
        done
        [[ "$all" =~ "$me" ]] || all="$all $me"
    done < <(egrep "^# Required scripts" *-*)
}
dep_clean(){
    for me in $all;do
        for sb in ${sub[$me]};do
            for sp in ${super[$me]};do
                sub[$sp]=${sub[$sp]//$sb/}
                super[$sb]=${super[$sb]//$sp/}
            done
        done
    done
}
show_tree(){
    [ "${#2}" -gt  100 ] && _abort "Infinite Loop Error"
    local ind="    |$2"
    for i in ${sub[$1]};do
        echo "${ind}---$i"
        show_tree $i "$ind"
    done
}
### main ###
cd ~/bin
declare -A sub
declare -A super
declare -A depth

dep_list
dep_clean
echo "func.getpar"
show_tree "func.getpar"
