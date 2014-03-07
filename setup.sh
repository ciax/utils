#!/bin/bash
# rcfile priority (bash executes just one of them)
# Invoked bash as a Login shell
#  .bash_profile > .bash_login > .profile (calls .bashrc)
# Merely invoked
#  .bashrc (calls .bash_aliases)
. ~/utils/func.color.sh
color5 "Registering Files"
~/utils/file-register.sh
color5 "Installing Packages"
pkg-deb init
color5 "Updating Database"
upd-db
color5 "Initializing SSH"
ssh-setup
