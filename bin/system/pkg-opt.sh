#!/bin/bash
#link(QNAP) pkg
# Required scripts: func.getpar show-required
# Description: Package utils for Optware (Qnap)
. func.getpar
which ipkg >/dev/null || _abort "This might not have Optware"
which sudo >/dev/null || _abort "Need 'sudo' installed or to be root"
_caselist | _usage "[option]"
cmd="$1";shift
case "$cmd" in
    init) #install required packages
        sudo -i ipkg install $(show-required packages);;
    upd) #update and upgrade packages
        sudo -i ipkg update ;;
    list) #list installed packages
        sudo ipkg list_installed;;
    develop) #package for development (gcc,headers)
        sudo -i ipkg install gcc || _abort "Error $?"
        echo Install success. $?
        ;;
    install) #install packages
        _usage "[$cmd] [packages]"
        sudo -i ipkg install $* || _abort "Error $?"
        echo Install success. $?
        ;;
    remove) #remove packages
        _usage "[$cmd] [package]"
        sudo -i ipkg remove --purge $*;;
    where) #show packages that isn't installed
        _usage "[$cmd] [file]"
        sudo ipkg list "*bin/$1";;
    search) #search package
        _usage "[$cmd] [pattern]"
        sudo ipkg search "$1";;
    files) #show package contents
        _usage "[$cmd] [package]"
        sudo ipkg files "$1";;
    info) #show package info
        _usage "[$cmd] [package]"
        sudo ipkg info "$1";;
    *);;
esac
