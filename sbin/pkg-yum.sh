#!/bin/bash
#link(CentOS) pkg
# Required scripts: func.getpar list-required
# Description: Debian package utils
. func.sudo
which yum >/dev/null || _abort "This might not RedHat"
cmd="$1";shift
case "$cmd" in
    init) #install required packages
        _sudy -i yum install $(list-required packages);;
    upd) #update and upgrade packages
        _sudy -i yum update ;;
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
            _caseitem | _colm | _abort
        }
    ;;
esac
