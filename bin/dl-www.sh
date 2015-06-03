#!/bin/bash
# Required packages : wget nkf
# Description : Repricate web site. The config file is in ~/cfg.*/env.
usage(){
    #Show Usage and List
    while read cfg; do
        str="$str $(basename $cfg .env)"
    done < <(ls ~/cfg.*/env/*.env)
    echo "Usage: ${0##*/} [project]"
    echo "  $str"
    exit 1
}
proj=$1
source ~/cfg.*/env/$proj.env 2> /dev/null || usage
dir=~/.var/$proj
exp=/var/www/html/$proj
[ -d $dir ] || mkdir $dir
[ -h $exp ] || sudo ln -sf $dir $exp
cd $dir
if [ "$index" ]; then
    wget -N $url/$index
    echo "Retriving files in $index"
    while read line; do
        file=${line#*=}
        wget -N $url/$file
    done < <(grep "file=" $index|nkf -Lu)
else
    wget -N $url
fi

