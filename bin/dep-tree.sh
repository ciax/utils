#!/bin/bash
# Description: show script dependency tree ('*'=independent)
. func.getpar
core(){
    base="${1##*/}"
    echo "${base%.*}"
}
# Get data from STDIN
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
    local f=$1 n=${2:-0}
    [[ "$deps" =~ " $f " ]] && _abort "Cyclic depencency detected $deps vs $f" || deps+="$f "
    [ $n -gt  50 ] && _abort "Infinite Loop Error $f"
    [ ${rank[$top]:-0} -lt $n ] && rank[$top]=$n
    for sb in ${sub0[$f]};do
        [ ${depth[$sb]:-0} -le $n ] || continue
        depth[$sb]=$n
        super[$sb]=$f
        index=${index// $sb / }
        dep_dig "$sb" $(($n+1))
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
declare -A rank
index=' '
deps=' '
make_list
for top in ${start:-$index};do
    dep_dig "$top"
done
dep_stack
for top in ${start:-$index};do
    if [ "${sub0[$top]}" ] ; then
        n=${rank[$top]}
        echo $C3"$top${n:+($n)}"$C0
    else
        echo $C5"*$top"$C0
    fi
    show_tree "$top"
done
