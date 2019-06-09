#!/bin/bash
# Required packages(Debian,Raspbian,Ubuntu): apt-file
# Required scripts: func.getpar
# Description: Debian package info
. func.getpar
which apt-get >/dev/null || _abort "This might not Debian"
cmd="$1";shift
case "$cmd" in
    required) #list required packages
        for i in $(list-required packages); do
            apt-cache search "^$i$" || echo "No such apackage $i"
        done
        ;;
    list) #list installed packages
        dpkg --get-selections '*'
    ;;
    tasks) #list tasks
        tasksel --list-tasks
    ;;
    which) #show package which includes file
        _usage "[$cmd] [file]"
        par=`which "$1"` && par=`readlink -f $par` || par=$1
        dpkg -S $par
    ;;
    where) #show package that isn't installed
        _usage "[$cmd] [file]"
        apt-file search "bin/$1 "
    ;;
    search) #search package
        _usage "[$cmd] [pattern]"
        apt-cache search $1|sort|grep --color=auto $1
    ;;
    files) #show package contents
        _usage "[$cmd] [package]"
        dpkg -L "$1"
    ;;
    info) #show package info
        _usage "[$cmd] [package]"
        dpkg -s "$1"
    ;;
    stat) #show package status
        _usage "[$cmd] [package]"
        dpkg -l "$1"
    ;;
    *)
        _disp_usage "[command]"
        _caseitem | _colm 1>&2
        _fexit 2
    ;;
esac
