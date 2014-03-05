#!/bin/bash
#Debian utils
# Required Packages: apt-spy,debconf
#alias deb
shopt -s nullglob
which apt-get >/dev/null || { echo "This might not Debian"; exit; }
which sudo >/dev/null || { echo "Need 'sudo' installed or to be root"; exit; }
ichk(){ for i ;do which $i >/dev/null || sudo apt-get install $i;done; }
ipkgs(){
    [ "$1" ] || return
    grep -ih '^# *req.* packages' $*|tr -d ' '|\
    sed -re 's/\([^\)]+\)//g' -e 's/.*://'|\
    tr ',' '\n'|sort -u
}
cmd="$1";shift
case "$cmd" in
    init)
        ichk grep sed
        sudo apt-get install $(ipkgs *.sh)
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
[ "$1" ] || . set.usage "[option]" "which (file)" "search (pattern)" \
            "install,remove,config (package)" "files,stat,info (package)" \
            "gpg (key)" "init,list; spy; clean; upd; upg"
case "$cmd" in
    install)
        sudo apt-get install $* || { echo "Error $?"; exit; }
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
        par=`which "$1"` && par=`readlink -f $par` || par=$1
        dpkg -S $par;;
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
