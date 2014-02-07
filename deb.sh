#!/bin/bash
#Debian utils
which apt-get >/dev/null || { echo "This might not Debian"; exit; }
which sudo >/dev/null || { echo "Need 'sudo' installed or to be root"; exit; }
ichk(){ for i ;do which $i >/dev/null || sudo apt-get install $i;done; }
case "$1" in
    init)
        ichk grep sed
        apps=`grep -h '^#' *.sh|grep -i 'req.* packages'|tr -d ' '|sed -re 's/\([^)]+\)//g' -e 's/.*://'| tr ',' '\n' | sort -u`
        sudo apt-get install $apps
        exit;;
    clean)
        ichk deborphan
        sudo apt-get autoremove
        sudo apt-get remove --purge `deborphan` `dpkg --get-selections '*'|grep deinstall|cut -f1`
        exit;;
    spy)
        ichk apt-spy
        sudo apt-spy -d stable -a North-America
        exit;;
    upd)
        sudo apt-get update
        exit;;
    upg)
        sudo apt-get upgrade
        exit;;
    list)
        dpkg --get-selections '*'
        exit;;
    *);;
esac
shift
[ "$1" ] || . set.usage "[option]" "init" "which (file)" "search (pattern)" \
            "install,remove,config (package)" "files,stat,info (package)" \
            "gpg (key)" "list; spy; clean; upd; upg"
case $1 in
    install)
        shift
        sudo apt-get $* || { echo "Error $?"; exit; }
        echo Install success. $?
        ;;
    remove)
        sudo apt-get remove --purge $1;;
    config)
        sudo dpkg-reconfigure $1;;
    gpg)
        gpg --keyserver pgpkeys.mit.edu --recv-keys $1 &&\
    gpg --armor --export $1 | sudo apt-key add -;;
    which)
        cmd=`which "$1"` && cmd=`readlink -f $cmd` || cmd=$1
        dpkg -S $cmd;;
    search)
        apt-cache search $1;;
    files)
        dpkg -L "$1";;
    info)
        dpkg -s "$1";;
    stat)
        dpkg -l "$1";;
    *);;
esac