#!/bin/bash
# Description: Export dir as link
#alias lnw
. func.sudo
[ "$1" ] || { echo "Usage: sys-link-www [dir]"; exit 1; }
dir=$1
exp=/var/www/html/$dir
if [ ! -d $dir ] ; then
    echo "$dir is not exist"
    exit 1
elif [ ! -h $exp ]; then
    _sudy ln -sf $dir $exp
    echo "link to $exp is created"
fi
