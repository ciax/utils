#!/bin/bash
# Description: setup rc files
setup(){
    local file=~/.$1;shift
    [ -e $file ] || touch $file
    head=$1;shift
    local line="$head ~/bin/rc.$* #initrc"
    # Case of no update
    grep -q "$line" "$file" && return
    # Case of update
    local tmp=~/.var/cache/bashrc.tmp
    mkdir -p ${tmp%/*}
    grep -v "#initrc" "$file" > "$tmp"
    mv "$tmp" "$file"
    echo "$line" >> "$file"
    echo "Update ${file##*/}"
}

for profile in bash_profile bash_login profile;do
    [ -e ~/.$profile ] && break
done
setup bashrc . bash
setup $profile nohup log in '&'
setup bash_logout nohup log out '&'
