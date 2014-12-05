#!/bin/bash
# Description: install utils (need to re-login for environment effective)
echo $C3"Setting up utils"$C0
cd ~/utils
. ./func.link.sh
. ./rc.utils.sh
bin/file-linkbin.sh
cd
file-linkcfg
. rc.utils.alias
pkg init
db-update
setup-bashrc
bkup-init
exec bash