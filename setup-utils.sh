#!/bin/bash
# Description: install utils (need to re-login for environment effective)
PATH=$PATH:~/bin
echo $C3"Installing Packages"$C0
set - $(</etc/issue)
DIST="$1"
~/utils/bin/file-register.sh
~/utils/bin/setup-bashrc.sh
pkg init
upd-git
upd-db
echo $C1"*** You need to re-login here***"$C0
