#!/bin/bash
#Debian utils
# Required Packages: apt-spy,debconf,findutils
#alias deb
shopt -s nullglob
which apt-get >/dev/null || { echo "This might not Debian"; exit; }
which sudo >/dev/null || { echo "Need 'sudo' installed or to be root"; exit; }
ichk(){ for i ;do which $i >/dev/null || sudo -i apt-get install $i;done; }
ipkgs(){
    [ "$1" ] || return
    grep -ihr '^# *req.* packages' $*|tr -d ' '|\
    sed -re 's/\([^\)]+\)//g' -e 's/.*://'|\
    tr ',' '\n'|sort -u
}
cmd="$1";shift
case "$cmd" in
    init)
        ichk grep sed
        sudo -i apt-get install $(ipkgs ~/utils/*.sh)
        exit;;
    clean)
        ichk deborphan
        sudo -i apt-get autoremove
        sudo -i apt-get remove --purge `deborphan` `dpkg --get-selections '*'|grep deinstall|cut -f1`
        exit;;
    spy)
        ichk apt-spy
        sudo -i apt-spy -d stable -a North-America
        exit;;
    upd)
        sudo -i apt-get update
        exit;;
    upg)
        sudo -i apt-get upgrade
        exit;;
    list)
        dpkg --get-selections '*'
        exit;;
    *);;
esac
. set.usage "[option]" $1 <<EOF
install,remove,config (package)
files,stat,info (package)
which (file)
search (pattern)
gpg (key)
init,list; spy; clean; upd; upg
EOF
case "$cmd" in
    install)
        sudo -i apt-get install $* || { echo "Error $?"; exit; }
        echo Install success. $?
        ;;
    remove)
        sudo -i apt-get remove --purge $1;;
    config)
        sudo -i dpkg-reconfigure $1;;
    gpg)
        gpg --keyserver pgpkeys.mit.edu --recv-keys $1 &&\
    gpg --armor --export $1 | sudo -i apt-key add -;;
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
