#!/bin/bash
# Description: show script dependency tree
#  '*' prefixed file -> independent file;
. func.getpar
core(){
    base="${1##*/}"
    echo "${base%.*}"
}
make_list(){
    while read shared user; do
        [[ "$all" =~ " $shared " ]] || all+="$shared "
        [ "$user" -a "$user" != "$shared" ] && sub0[$shared]+=" $user"
    done
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
_usage "<dep list>"
declare -A sub0
declare -A sub
declare -A super
declare -A depth
all=' '
make_list
for top in $all;do
    dep_dig "$top"
done
dep_stack
echo $C5"* = independent"$C0
for top in $all;do
    if [ "${sub0[$top]}" ] ; then
        echo $C3"$top"$C0
    else
        echo $C5"*$top"$C0
    fi
    show_tree "$top"
done
