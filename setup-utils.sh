#!/bin/bash
# Description: install utils (need to re-login for environment effective)
echo "Setting up utils"
. ~/utils/setup-links.sh
file-selflink
db-update
bashrc-setup
bkup-init
exec bash
