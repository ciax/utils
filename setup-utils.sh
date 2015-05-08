#!/bin/bash
# Description: install utils (need to re-login for environment effective)
echo "Setting up utils"
# Description: Dir setup and File registration
for dir in bin .var .trash; do
    [ -d "$HOME/$dir" ] || mkdir -p "$HOME/$dir"
done
PATH=$HOME/bin:$PATH
cd ~/utils/bin
. ./func.link.sh
_binreg
cd
file-selflink
db-update
bashrc-setup
bkup-init
exec bash
