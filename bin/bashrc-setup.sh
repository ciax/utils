#!/bin/bash
# Description: setup rc files
setup(){
    if ! grep -q '#initrc' ~/.$1 ; then
        echo "source ~/bin/rc.$2 #initrc" >> ~/.$1
        echo "Add line to $1"
    fi
}

profile=profile
[ -e ~/.bash_profile ] && profile=bash_profile
setup $profile login
setup bashrc bash
setup bash_logout logout
