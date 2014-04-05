#!/bin/bash
#link:CentOS pkg
# Required scripts: func.app, show-required
# Description: Debian package utils
. func.app
which yum >/dev/null || _abort "This might not RedHat"
which sudo >/dev/null || _abort "Need 'sudo' installed or to be root"
_usage "[option]" $(egrep -o '^ +[a-z]+\)' $0|sort|tr -d ')')
cmd="$1";shift
case "$cmd" in
    init)
        sudo -i yum install $(show-required packages)
        ;;
    upd)
        sudo -i yum update
        ;;
    list)
        rpm -qa
        ;;
    getheader)
        sudo -i yum install kernel-headers || _abort "Error $?"
        echo Install success. $?
        ;;
    install)
        _usage "[$cmd] [packages]"
        sudo -i yum install $* || _abort "Error $?"
        echo Install success. $?
        ;;
    remove)
        _usage "[$cmd] [package]"
        sudo -i yum remove --purge $1;;
    which)
        _usage "[$cmd] [file]"
        par=`which "$1"` && par=`readlink -f $par` || par=$1
        yum provides $par;;
    search)
        _usage "[$cmd] [pattern]"
        yum search "$1";;
    files)
        _usage "[$cmd] [package]"
        rpm -ql "$1";;
    info)
        _usage "[$cmd] [package]"
        rpm -qi "$1";;
    *);;
esac
