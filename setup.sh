#!/bin/bash
# rcfile priority (bash executes just one of them)
# Invoked bash as a Login shell
#  .bash_profile > .bash_login > .profile (calls .bashrc)
# Merely invoked
#  .bashrc (calls .bash_aliases)
hl(){ echo "$C5$*$C0"; }
. ~/utils/initrc.sh
hl "Registering Files"
~/utils/file-register.sh
hl "Installing Packages"
pkg-deb init
hl "Updating Database"
upd-db
hl "Initializing SSH"
ssh-setup
