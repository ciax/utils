#!/bin/bash
# Description: install utils (need to re-login for environment effective)
#
#* rcfile priority (bash executes just one of them)
# Invoked bash as a Login shell
#  .bash_profile > .bash_login > .profile (calls .bashrc)
# Merely invoked
#  .bashrc (calls .bash_aliases)
hl(){ echo "$C5$*$C0"; }
PATH=$PATH:~/bin
hl "Registering Files"
~/utils/file-register.sh
hl "Installing Packages"
pkg-deb init
hl "Updating Database"
upd-db
