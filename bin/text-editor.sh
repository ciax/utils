#!/bin/bash
# Required packages: emacs
# Required scripts: func.getpar
# Description: edit file with emacs as its owner
#alias e
. func.getpar
_usage "[file] (line) .."
args=''
getfile(){
    if [ -h "$1" ]; then
	file=$(readlink $1)
    else
	file="$1"
    fi
    cp -pub $file ~/.trash/
    bkup-stash $file
}

for file;do
    if [[ "$file" =~ ^[0-9]+$ ]] ; then
        args="+$file $args"
	continue
    fi
    if [ -s "$file" ];then
	getfile "$file"
    elif res=$(type -P "$file"); then
	getfile "$res"
    fi
    args="$file $args"
done
alias
$(_setcmd edit-sudo "$EDITOR") $args
