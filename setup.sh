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
ln -sf ~/utils/set.initrc.sh $ba
. $ba
. ~/utils/set.color.sh
echo "${C5}Registering Files$C0"
~/utils/file-register.sh ~/utils
echo "${C5}Installing Packages$C0"
pkg-deb init
echo "${C5}Updating Database$C0"
upd-db
echo "${C5}Initializing SSH$C0"
ssh-setup
