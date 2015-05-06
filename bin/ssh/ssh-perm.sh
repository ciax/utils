#!/bin/bash
# Description: set ssh related file permission
filemod(){
    mod="$1";shift
    for i ; do [ -f "$i" ] && chmod $mod $i; done
}
ath=~/.ssh/authorized_keys
inv=~/.ssh/invalid_keys
sec=~/.ssh/id_rsa
pub=~/.ssh/id_rsa.pub
cd;chmod 755 .
[ -d ~/.ssh ] && cd ~/.ssh || exit
chmod 700 .
filemod 600 $ath $inv $sec $pub
