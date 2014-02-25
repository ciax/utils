#!/bin/bash
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
