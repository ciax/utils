#!/bin/bash
# Description: install utils (need to re-login for environment effective)
PATH=$PATH:~/bin
echo $C3"Installing Packages"$C0
which apt-get >/dev/null || { echo "This might not Debian"; exit; }
which sudo >/dev/null || { echo "Need 'sudo' installed or to be root"; exit; }
ichk(){ for i ;do which $i >/dev/null || sudo -i apt-get install $i;done; }
ichk grep sed
sudo -i apt-get install coreutils diffutils grep
~/utils/bin/file-register.sh
echo $C1"*** You need to re-login here***"$C0