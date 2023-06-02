#!/bin/bash
# Description: using sudo library
type _sudy >/dev/null 2>&1 && return
. func.getpar
# SUDOR?
_sudy(){ # sudo with check
    which sudo >/dev/null || _abort "Need 'sudo' installed or to be root"
    if [ "$PASSWORD" ] ; then
	echo $PASSWORD | sudo -S $*
    elif egrep -q "^(sudo|wheel):.*[,:]$LOGNAME" /etc/group; then
	sudo $*
    else
	_abort "No sudo permission"
    fi
}

_delegate(){
    if [ "$LOGNAME" = "$user" ]; then
        $*
    else
        _sudy -u $user $*
    fi
}
_chkfunc $*
