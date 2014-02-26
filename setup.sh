#!/bin/bash
# rcfile priority (bash executes just one of them)
# Invoked bash as a Login shell
#  .bash_profile > .bash_login > .profile (calls .bashrc)
# Merely invoked
#  .bashrc (calls .bash_aliases)
cd
ba=.bash_aliases
if [ -f .bashrc ] ; then
    grep -q $ba .bashrc || { echo "Can't make setup"; exit 1; }
else
    ba=.bashrc
fi
ln -sf ~/utils/.bash_local $ba
cd ~/utils
./reg-files.sh
pkg-deb init
