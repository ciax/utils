#!/bin/bash
#alias dep
# Required scripts: func.getpar
# Description: show script dependency tree
. func.getpar

get_nodes(){
    while read h u; do
        sub[$u]="${sub[$u]}$h " # add itself to parent var
        super[$h]="$u"
    done < <(dep_list)
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
dep_list(){
    IFS=:
    while read child dmy list;do
        (
            IFS=,
            for i in $list;do
                echo "$child $i"
            done
        )
    done < <(grep "Required scripts" *-*)|sort -u
}
#_usage "[subnet]" <(db-list subnet)

declare -A sub
declare -A super

get_nodes
echo "func.getpar"
show_tree "func.getpar"
