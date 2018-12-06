#!/bin/bash
# Required scripts: func.getpar show-required
# Description: Debian package utils
. func.getpar
which yum >/dev/null || _abort "This might not RedHat"
cmd="$1";shift
case "$cmd" in
    list) #list installed packages
        rpm -qa ;;
    where) #show packages that isn't installed
        _usage "[$cmd] [file]"
        yum provides "*bin/$1";;
    search) #search package
        _usage "[$cmd] [pattern]"
        yum search "$1";;
    files) #show package contents
        _usage "[$cmd] [package]"
        rpm -ql "$1";;
    info) #show package info
        _usage "[$cmd] [package]"
        rpm -qi "$1";;
    *)
        _disp_usage "[command]"
        _caseitem | _colm 1>&2
        exit 1
    ;;
esac
