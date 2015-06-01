#!/bin/bash
# Required packages : wget nkf
# Description : Repricate web site. The config file is in ~/cfg.*/env.
proj=$1
source ~/cfg.*/env/$proj.env > /dev/null 2>&1 || {
    while read cfg; do
        str="$str $(basename $cfg .env)"
    done < <(ls ~/cfg.*/env/*.env)
    echo "Usage: ${0##*/} [project]"
    echo "  $str"
    exit 1
} 
dir=~/.var/$proj
exp=/var/www/html/$proj
[ -d $dir ] || mkdir $dir
[ -h $exp ] || sudo ln -sf $dir $exp
cd $dir
if [ "$index" ]; then
    [ -e $index ] && rm $index
    wget $url/$index
    echo "Retriving files in $index"
    while read line; do
        file=${line#*=}
        [ -e $file ] || wget $url/$file
    done < <(grep "$file" $index|nkf -Lu)
else
    wget $url
fi

