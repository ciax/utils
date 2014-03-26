#!/bin/bash
# Description: install utils (need to re-login for environment effective)
#
#* rcfile priority (bash executes just one of them)
# Invoked bash as a Login shell
#  .bash_profile > .bash_login > .profile (calls .bashrc)
# Merely invoked
#  .bashrc (calls .bash_aliases)
PATH=$PATH:~/bin
echo $C3"Installing Packages"$C0
which apt-get >/dev/null || { echo "This might not Debian"; exit; }
which sudo >/dev/null || { echo "Need 'sudo' installed or to be root"; exit; }
ichk(){ for i ;do which $i >/dev/null || sudo -i apt-get install $i;done; }
ichk grep sed
sudo -i apt-get install coreutils diffutils
~/utils/bin/file-register.sh
echo $C1"*** You need to re-login here***"$C0