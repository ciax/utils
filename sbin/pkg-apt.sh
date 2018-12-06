#!/bin/bash
#link(Debian) pkg
#link(Ubuntu) pkg
#link(Raspbian) pkg
# Required packages(Debian,Raspbian,Ubuntu): deborphan apt-file screen
# Required scripts: func.getpar show-required
# Description: Debian package utils
. func.getpar
which apt-get >/dev/null || _abort "This might not Debian"
cmd="$1";shift
case "$cmd" in
    init) #install required packages
        _sudo -i apt-get install -y $(show-required packages)
        ;;
    clean) #clean up pakcages
        _sudo -i apt-get autoremove -y
        _sudo -i apt-get remove -y --purge `deborphan` `dpkg --get-selections '*'|grep deinstall|cut -f1`
        ;;
    upd) #update db
        _sudo -i apt-get update
        ;;
    upg) #upgrade packages
        _sudo screen apt-get upgrade -y
        ;;
    dist) #upgrade distribution
        _sudo screen apt-get dist-upgrade -y
        ;;
    develop) #install gcc and linux-headers for vmware
        _sudo apt-get install gcc linux-headers-$(uname -r) || _abort "Error $?"
        echo Install success. $?
        ;;
    install) #install packages
        _usage "[$cmd] [packages]"
        _sudo -i apt-get install -y $* || _abort "Error $?"
        echo Install success. $?
        ;;
    remove) #remove packages
        _usage "[$cmd] [package]"
        _sudo -i apt-get remove -y --purge $*;;
    config) #configure package
        _usage "[$cmd] [package]"
        _sudo -i dpkg-reconfigure $1;;
    gpg) #set gpg for sources
        _usage "[$cmd] [key]"
        gpg --keyserver pgpkeys.mit.edu --recv-keys $1 && gpg --armor --export $1 | _sudo -i apt-key add -;;
    *)
        info-apt $cmd $* || {
            _caseitem | _colm 1>&2
            exit 1
        }
        ;;
esac
