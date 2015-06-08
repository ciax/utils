#!/bin/bash
# Description: setup rc files
setup(){
    local file=~/.$1
    local line=". ~/bin/rc.$2 #initrc"
    grep -q "$line" "$file" && return
    local tmp=~/.var/tmpfile
    grep -v "$line" "$file" > "$tmp"
    mv "$tmp" "$file"
    echo "$line" >> "$file"
    echo "Update .$1"
}

for profile in bash_profile bash_login profile;do
    [ -e ~/.$profile ] && break
done
setup $profile login
setup bashrc bash
setup bash_logout logout
