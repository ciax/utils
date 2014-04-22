#!/bin/bash
#alias apt
#alias wf which
#link:Debian pkg
#link:Ubuntu pkg
# Required packages: deborphan,apt-file,apt-spy
# Required scripts: func.getpar, show-required
# Description: Debian package utils
. func.getpar
which apt-get >/dev/null || _abort "This might not Debian"
which sudo >/dev/null || _abort "Need 'sudo' installed or to be root"
_usage "[command]" <(_caselist)
cmd="$1";shift
case "$cmd" in
    init) #install required packages
        sudo -i apt-get install $(show-required packages)
        ;;
    clean) #clean up pakcages
        sudo -i apt-get autoremove
        sudo -i apt-get remove --purge `deborphan` `dpkg --get-selections '*'|grep deinstall|cut -f1`
        ;;
    spy) #apt-spy is not provided in ubuntu
        sudo -i apt-spy -d stable -a North-America
        ;;
    upd) #update db
        sudo -i apt-get update
        ;;
    upg) #upgrade packages
        sudo -i apt-get upgrade
        ;;
    list) #list installed packages
        dpkg --get-selections '*'
        ;;
    tasks) #list tasks
        tasksel --list-tasks
        ;;
    getheader) #install linux-headers for vmware
        sudo apt-get install linux-headers-$(uname -r) || _abort "Error $?"
        echo Install success. $?
        ;;
    install) #install package
        _usage "[$cmd] [packages]"
        sudo -i apt-get install $* || _abort "Error $?"
        echo Install success. $?
        ;;
    remove) #remove package
        _usage "[$cmd] [package]"
        sudo -i apt-get remove --purge $1;;
    config) #configure package
        _usage "[$cmd] [package]"
        sudo -i dpkg-reconfigure $1;;
    gpg) #set gpg for sources
        _usage "[$cmd] [key]"
        gpg --keyserver pgpkeys.mit.edu --recv-keys $1 && gpg --armor --export $1 | sudo -i apt-key add -;;
    which) #show package which includes file
        _usage "[$cmd] [file]"
        par=`which "$1"` && par=`readlink -f $par` || par=$1
        dpkg -S $par;;
    where) #show package which not installed
        _usage "[$cmd] [file]"
        apt-file search "bin/$1 ";;
    search) #search package
        _usage "[$cmd] [pattern]"
        apt-cache search $1;;
    files) #show package contents
        _usage "[$cmd] [package]"
        dpkg -L "$1";;
    info) #show package info
        _usage "[$cmd] [package]"
        dpkg -s "$1";;
    stat) #show package status
        _usage "[$cmd] [package]"
        dpkg -l "$1";;
    *);;
esac
