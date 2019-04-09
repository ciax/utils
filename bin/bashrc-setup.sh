#!/bin/bash
# Description: setup rc files
setup(){
    local file=~/.$1
    [ -e $file ] || touch $file
    local line=". ~/bin/rc.$2 $3 #initrc"
    # Case of no update
    grep -q "$line" "$file" && return
    # Case of update
    local tmp=~/.var/cache/bashrc.tmp
    mkdir -p ${tmp%/*}
    grep -v "#initrc" "$file" > "$tmp"
    mv "$tmp" "$file"
    echo "$line" >> "$file"
    echo "Update .$1"
}

for profile in bash_profile bash_login profile;do
    [ -e ~/.$profile ] && break
done
setup $profile log in
setup bashrc bash
setup bash_logout log out
