#!/bin/bash
# Description: install utils (need to re-login for environment effective)
echo "Setting up utils"
cd ~/utils
. ./func.link.sh
bin/file-linkbin.sh
cd
file-linkcfg
pkg init
db-update
bashrc-setup
bkup-init
exec bash
