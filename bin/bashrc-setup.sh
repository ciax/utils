#!/bin/bash
# Description: setup rc files
setup(){
    grep -v '#initrc' ~/.$1 > ~/.var/tmpfile
    mv ~/.var/tmpfile ~/.$1
    echo "source ~/bin/rc.$2 #initrc" >> ~/.$1
    echo "Update .$1"
}

profile=profile
[ -e ~/.bash_profile ] && profile=bash_profile
setup $profile login
setup bashrc bash
setup bash_logout logout
