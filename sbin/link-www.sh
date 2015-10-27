#!/bin/bash
# Description : Export dir as link
#alias lnw
[ "$1" ] || { echo "Usage: ln-www [dir]"; exit 1; }
dir=$1
exp=/var/www/html/$dir
if [ ! -d $dir ] ; then
    echo "$dir is not exist"
    exit 1
elif [ ! -h $exp ]; then
    sudo ln -sf $dir $exp
    echo "link to $exp is created"
fi
