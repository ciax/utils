#!/bin/bash
#link(CentOS) pkg
# Required scripts: func.getpar show-required
# Description: Debian package utils
. func.getpar
which yum >/dev/null || _abort "This might not RedHat"
cmd="$1";shift
case "$cmd" in
    init) #install required packages
        _sudy -i yum install $(show-required packages);;
    upd) #update and upgrade packages
        _sudy -i yum update ;;
    list) #list installed packages
        rpm -qa ;;
    develop) #package for development (gcc,headers)
        _sudy -i yum install gcc || _abort "Error $?"
        echo Install success. $?
        ;;
    install) #install packages
        _usage "[$cmd] [packages]"
        _sudy -i yum install $* || _abort "Error $?"
        echo Install success. $?
        ;;
    remove) #remove packages
        _usage "[$cmd] [package]"
        _sudy -i yum remove --purge $*;;
    *)
        info-yum $cmd $* || {
            _caseitem | _colm 1>&2
            exit 1
        }
    ;;
esac
