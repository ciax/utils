#!/bin/bash
# rcfile priority (bash executes just one of them)
# Invoked bash as a Login shell
#  .bash_profile > .bash_login > .profile (calls .bashrc)
# Merely invoked
#  .bashrc (calls .bash_aliases)
cd
ba=.bash_aliases
if [ -f .bashrc ] ; then
    grep -q $ba .bashrc || echo "Can't linked rc file"
else
    ba=.bashrc
fi
ln -sf ~/utils/.bash_local $ba
. $ba
echo "Registering Files"
~/utils/file-register.sh ~/utils
echo "Installing Packages"
pkg-deb init
echo "Updating Database"
upd-db
echo "Initializing SSH"
ssh-setup
