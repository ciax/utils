#!/bin/bash
# Description: using sudo library
type _sudy >/dev/null 2>&1 && return
. func.getpar
# SUDOR?
_sudy(){ # sudo with check
    which sudo >/dev/null || _abort "Need 'sudo' installed or to be root"
    egrep -q "^(sudo|wheel):.*[,:]$LOGNAME" /etc/group || _abort "No sudo permission"
    [ "$PASSWORD" ] && echo $PASSWORD | sudo -S $* || sudo $*
}

_delegate(){
    _sudy $*
}
_chkfunc $*
