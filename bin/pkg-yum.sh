#!/bin/bash
#link(CentOS) pkg
# Required scripts: func.getpar, show-required
# Description: Debian package utils
. func.getpar
which yum >/dev/null || _abort "This might not RedHat"
which sudo >/dev/null || _abort "Need 'sudo' installed or to be root"
_usage "[option]" <(_caselist)
cmd="$1";shift
case "$cmd" in
    init) #install required packages
        sudo -i yum install $(show-required packages);;
    upd) #update and upgrade packages
        sudo -i yum update ;;
    list) #list installed packages
        rpm -qa ;;
    develop) #package for development (gcc,headers)
        sudo -i yum install gcc || _abort "Error $?"
        echo Install success. $?
        ;;
    install) #install packages
        _usage "[$cmd] [packages]"
        sudo -i yum install $* || _abort "Error $?"
        echo Install success. $?
        ;;
    remove) #remove packages
        _usage "[$cmd] [package]"
        sudo -i yum remove --purge $*;;
    where) #show packages that isn't installed
        _usage "[$cmd] [file]"
        yum provides $(which "$1");;
    search) #search package
        _usage "[$cmd] [pattern]"
        yum search "$1";;
    files) #show package contents
        _usage "[$cmd] [package]"
        rpm -ql "$1";;
    info) #show package info
        _usage "[$cmd] [package]"
        rpm -qi "$1";;
    *);;
esac
