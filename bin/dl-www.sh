#!/bin/bash
# Required packages: wget nkf
# Description: Repricate web site. The config file is in ~/cfg.*/env.
usage(){
    #Show Usage and List
    while read cfg; do
        str="$str $(basename $cfg .wget)"
    done < <(ls ~/cfg.*/etc/*.wget)
    echo "Usage: ${0##*/} [project]"
    echo "  $str"
    exit 1
}
proj=$1
source ~/cfg.*/etc/$proj.wget 2> /dev/null || usage
dir=~/.var/cache/$proj
mkdir -p $dir
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

