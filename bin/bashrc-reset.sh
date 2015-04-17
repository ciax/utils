#!/bin/bash
# Description: reset dot files
shopt -s dotglob
[ -d /etc/skel ] && cp /etc/skel/* ~/
echo "Reset Bashrc!"
