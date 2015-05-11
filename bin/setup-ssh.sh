#!/bin/bash
# Required packages: openssh-server
# Required scripts: ssh-config
# Desctiption: setup ssh files 
# Usage: ${0##*/} (-r:remove keys)
. func.getpar
. func.ssh
_warn "Initializing SSH"
[ "$1" = -r ] && rm ~/$SEC ~/$PUB
_ssh-setup
ssh-config > ~/$CFG
