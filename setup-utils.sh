#!/bin/bash
# Description: install utils (need to re-login for environment effective)
echo $C3"Setting up utils"$C0
cd ~/utils
. ./rc.utils.sh
. ./func.link.sh
file-reg
pkg init
db-update
setup-bashrc
echo $C1"*** You need to invoke 'exec bash' here***"$C0
