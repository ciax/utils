#!/bin/bash
# Description: install utils (need to re-login for environment effective)
ichk(){
    for i ;do
        which $i >/dev/null && continue
        sudo -i apt-get install $i
        [ "$i" = apt-file ] && apt-file update
    done
}
initrc(){
    [ -f ~/.bashrc ] && grep -q '#initrc' ~/.bashrc && return
    echo 'shopt -s nullglob;for i in ~/bin/rc.*;do . $i;done #initrc' >> ~/.bashrc
}
PATH=$PATH:~/bin
echo $C3"Installing Packages"$C0
which apt-get >/dev/null || { echo "This might not Debian"; exit; }
which sudo >/dev/null || { echo "Need 'sudo' installed or to be root"; exit; }
ichk grep sed nkf sqlite3 apt-file
~/utils/bin/file-register.sh
initrc
echo $C1"*** You need to re-login here***"$C0


