#!/bin/bash
# Description: show script dependency tree ('*'=independent)
. func.getpar
core(){
    base="${1##*/}"
    echo "${base%.*}"
}
make_list(){
    while read shared user; do
        [[ "$index" =~ " $shared " ]] || index+="$shared "
        [ "$user" -a "$user" != "$shared" ] || continue
        sub0[$shared]+=" $user"
        # detecting inter-dependency
        [[ ${sub0[$user]} =~ " $shared " ]] && _abort "Inter-dependency $shared <-> $user"
    done
}
dep_dig(){
    [[ "$deps" =~ " $1 " ]] && _abort "Cyclic depencency detected $deps vs $1" || deps+="$1 "
    [ "${2:-0}" -gt  50 ] && _abort "Infinite Loop Error $1"
    for sb in ${sub0[$1]};do
        [ "${depth[$sb]:-0}" -le ${2:-0} ] || continue
        depth[$sb]=$2
        super[$sb]=$1
        index=${index// $sb / }
        dep_dig "$sb" $(($2+1))
    done
    deps="${deps%$1*}"
}
dep_stack(){
    for me in ${!super[*]};do
        local sup=${super[$me]}
        sub[$sup]+=" $me"
    done
}
show_tree(){
    [ "${#2}" -gt  200 ] && _abort "Infinite Loop Error"
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
_usage "(top) < dep_list"
start=$1;shift
declare -A sub0
declare -A sub
declare -A super
declare -A depth
index=' '
deps=' '
make_list
for top in ${start:-$index};do
    dep_dig "$top"
done
dep_stack
for top in ${start:-$index};do
    if [ "${sub0[$top]}" ] ; then
        echo $C3"$top"$C0
    else
        echo $C5"*$top"$C0
    fi
    show_tree "$top"
done
