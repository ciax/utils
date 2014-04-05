#!/bin/bash
#alias apt
#alias wf which
# Required commands: sed,find,deborphan,apt-spy,gpg,tasksel
# Required scripts: func.app, show-required
# Description: Debian package utils
. func.app
which apt-get >/dev/null || _abort "This might not Debian"
which sudo >/dev/null || _abort "Need 'sudo' installed or to be root"
_usage "[option]" $(egrep -o '^ +[a-z]+\)' $0|sort|tr -d ')')
cmd="$1";shift
case "$cmd" in
    init)
        sudo -i apt-get install $(show-required packages)
        ;;
    clean)
        sudo -i apt-get autoremove
        sudo -i apt-get remove --purge `deborphan` `dpkg --get-selections '*'|grep deinstall|cut -f1`
        ;;
    spy)
        # apt-spy is not provided in ubuntu
        sudo -i apt-spy -d stable -a North-America
        ;;
    upd)
        sudo -i apt-get update
        ;;
    upg)
        sudo -i apt-get upgrade
        ;;
    list)
        dpkg --get-selections '*'
        ;;
    tasks)
        tasksel --list-tasks
        ;;
    getheader)
        sudo apt-get install linux-headers-$(uname -r) || _abort "Error $?"
        echo Install success. $?
        ;;
    install)
        _usage "[$cmd] [packages]"
        sudo -i apt-get install $* || _abort "Error $?"
        echo Install success. $?
        ;;
    remove)
        _usage "[$cmd] [package]"
        sudo -i apt-get remove --purge $1;;
    config)
        _usage "[$cmd] [package]"
        sudo -i dpkg-reconfigure $1;;
    gpg)
        _usage "[$cmd] [key]"
        gpg --keyserver pgpkeys.mit.edu --recv-keys $1 && gpg --armor --export $1 | sudo -i apt-key add -;;
    which)
        _usage "[$cmd] [file]"
        par=`which "$1"` && par=`readlink -f $par` || par=$1
        dpkg -S $par;;
    search)
        _usage "[$cmd] [pattern]"
        apt-cache search $1;;
    files)
        _usage "[$cmd] [package]"
        dpkg -L "$1";;
    info)
        _usage "[$cmd] [package]"
        dpkg -s "$1";;
    stat)
        _usage "[$cmd] [package]"
        dpkg -l "$1";;
    *);;
esac
