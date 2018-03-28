#!/bin/bash
# Required packages: openssh-server
# Required scripts: ssh-config
# Description: setup ssh files 
# Usage: ${0##*/} (-r:remove keys)
. func.getpar
. func.ssh
_warn "Initializing SSH"
[ "$1" = -r ] && rm -f $SEC $PUB
_ssh_setup
ssh-config > $CFG
