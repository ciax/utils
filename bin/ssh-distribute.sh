#!/bin/bash
# Required scripts: ssh-join func.ssh
# Description: join to the group which opject host is involved
# Usage: ssh-merge (user@host) ..
#   If no args, then hosts are picked up from authorized_keys
set -e
. func.ssh
cd ~/.var/ssh/admit
cp $LATH $ATH
for rem in $(_ssh-rem-validate $(_ssh-auth-mates));do
    _ssh-rem-push $rem
done
