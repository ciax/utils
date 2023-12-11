#!/bin/bash
#link(Debian) pkg
#link(Ubuntu) pkg
#link(Raspbian) pkg
# Required packages(Debian,Raspbian,Ubuntu): deborphan apt-file screen
# Required scripts: func.getpar list-required
# Description: Debian package utils
. func.sudo
# _sudy accepts $PASSWORD authentification
which apt-get >/dev/null || _abort "This might not Debian"
cmd="$1";shift
err=~/.var/apt.err
gpg=~/.var/temp.gpg
case "$cmd" in
    attach) #attach screen to the background pkg process 
	_sudy screen -D -R
	;;
    init) #install required packages
        _sudy -i apt-get install -y $(list-required packages)
        ;;
    clean) #clean up pakcages
        _sudy -i apt-get autoremove -y
        _sudy -i apt-get remove -y --purge `deborphan` `dpkg --get-selections '*'|grep deinstall|cut -f1`
        ;;
    upd) #update db
        _sudy -i apt-get update 2> $err
	# in case of PGP error
	if [ -s $err ]; then
	    cd /etc/apt/trusted.gpg.d/
	    while read dist key; do
		echo "$dist,$key"
		gpg --keyserver keyserver.ubuntu.com --recv-keys $key && gpg --export $key > $gpg
		_sudy -i mv $gpg $dist.gpg
	    done < <(egrep -o 'GPG.+' $err | cut -d: -f3,5|cut -d' ' -f2,5| tr -d '/')
	    sys-chown
	fi
        ;;
    upg) #upgrade packages
        _sudy screen apt-get upgrade -y
        ;;
    dist) #upgrade distribution
        _sudy screen apt-get dist-upgrade -y
        ;;
    develop) #install gcc and linux-headers for vmware
        _sudy apt-get install gcc linux-headers-$(uname -r) || _abort "Error $?"
        echo Install success. $?
        ;;
    install) #install packages
        _usage "[$cmd] [packages]"
        _sudy -i apt-get install -y $* || _abort "Error $?"
        echo Install success. $?
        ;;
    remove) #remove packages
        _usage "[$cmd] [package]"
        _sudy -i apt-get remove -y --purge $*
	;;
    config) #configure package
        _usage "[$cmd] [package]"
        _sudy -i dpkg-reconfigure $1
	;;
    gpg) #set gpg for sources
        _usage "[$cmd] [key]"
        gpg --keyserver keyserver.ubuntu.com --recv-keys $1 && gpg --armor --export $1
	;;
    *)
        . info-apt $cmd $*
        ;;
esac
