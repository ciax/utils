#!/bin/bash
# Description: setup rc files
update(){
    file="$1";line="$2"
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
setrc(){
    local file=~/.$1;shift
    [ -e $file ] || touch $file
    local line="$1 ~/bin/rc."
    shift
    line+="$* #initrc"
    update "$file" "$line"
}

setrc bashrc source bash
for profile in bash_profile bash_login profile;do
    [ -e ~/.$profile ] && break
done
setrc $profile nohup login '> ~/.var/log/rc.login.log 2>&1 &'
setrc bash_logout nohup logout '> ~/.var/log/rc.logout.log 2>&1 &'
file-register

