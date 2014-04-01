#!/bin/bash
#alias pkg
#alias wf which
# Required packages: sudo,grep,sed,apt-spy,debconf,findutils,deborphan
# Required scripts: func.app, show-required
# Description: Debian package utils
. func.app
which apt-get >/dev/null || _abort "This might not Debian"
which sudo >/dev/null || _abort "Need 'sudo' installed or to be root"
_usage "[option]" "install remove config files stat info which search gpg init list spy clean upd upg"
cmd="$1";shift
case "$cmd" in
    init)
        sudo -i apt-get install $(show-required packages)
        exit;;
    clean)
        sudo -i apt-get autoremove
        sudo -i apt-get remove --purge `deborphan` `dpkg --get-selections '*'|grep deinstall|cut -f1`
        exit;;
    spy)
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
case "$cmd" in
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
