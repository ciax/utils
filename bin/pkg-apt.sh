#!/bin/bash
#link(Debian) pkg
#link(Ubuntu) pkg
#link(Raspbian) pkg
# Required packages(Ubuntu): deborphan apt-file
# Required packages(Debian,Raspbian): deborphan apt-file apt-spy
# Required scripts: func.getpar show-required
# Description: Debian package utils
. func.getpar
which apt-get >/dev/null || _abort "This might not Debian"
which sudo >/dev/null || _abort "Need 'sudo' installed or to be root"
_usage "[command]" < <(_caselist)
cmd="$1";shift
case "$cmd" in
    init) #install required packages
        sudo -i apt-get install -y $(show-required packages)
        ;;
    clean) #clean up pakcages
        sudo -i apt-get autoremove -y
        sudo -i apt-get remove -y --purge `deborphan` `dpkg --get-selections '*'|grep deinstall|cut -f1`
        ;;
    upd) #update db
        sudo -i apt-get update
        ;;
    upg) #upgrade packages
        sudo -i apt-get upgrade -y
        sudo -i apt-get dist-upgrade -y
        ;;
    list) #list installed packages
        dpkg --get-selections '*'
        ;;
    tasks) #list tasks
        tasksel --list-tasks
        ;;
    develop) #install gcc and linux-headers for vmware
        sudo apt-get install gcc linux-headers-$(uname -r) || _abort "Error $?"
        echo Install success. $?
        ;;
    install) #install packages
        _usage "[$cmd] [packages]"
        sudo -i apt-get install -y $* || _abort "Error $?"
        echo Install success. $?
        ;;
    remove) #remove packages
        _usage "[$cmd] [package]"
        sudo -i apt-get remove -y --purge $*;;
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
    where) #show package that isn't installed
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
