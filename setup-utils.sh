#!/bin/bash
# Description: install utils (need to re-login for environment effective)
cd ~/utils
. ./func.link.sh
_binreg
file-reg
pkg init
db-update
setup-bashrc.sh
echo $C1"*** You need to invoke 'exec bash' here***"$C0
