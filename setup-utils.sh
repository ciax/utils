#!/bin/bash
# Description: install utils (need to re-login for environment effective)
cd ~/utils
./reg-bin.sh
. setup-bashrc
rec-dirs reg-bin
pkg init
db-update
echo $C1"*** You need to invoke 'exec bash' here***"$C0
