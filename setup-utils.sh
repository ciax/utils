#!/bin/bash
# Description: install utils (need to re-login for environment effective)
echo $C3"Setting up utils"$C0
cd ~/utils
. ./func.link.sh
. ./rc.login.sh
bin/file-linkbin.sh
cd
file-linkcfg
pkg init
db-update
bashrc-setup
bkup-init
exec bash