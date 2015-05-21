#!/bin/bash
# Required scripts: ssh-join func.ssh
# Description: join to the group which opject host is involved
# Usage: ssh-merge (user@host) ..
#   If no args, then hosts are picked up from authorized_keys
set -e
. func.ssh
cd ~/.var/ssh/admit
cp $LATH $ATH
for rem in $(_rem-valid $(_auth-mates));do
    _rem-push $rem
done
