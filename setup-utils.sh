#!/bin/bash
# Description: install utils (need to re-login for environment effective)
# Required packages(QNAP): man emacs22 sudo
echo $C3"Setting up utils"$C0
cd ~/utils
. ./func.link.sh
. ./rc.bash.sh
bin/file-linkbin.sh
cd
file-linkcfg
pkg init
db-update
bashrc-setup
bkup-init
exec bash