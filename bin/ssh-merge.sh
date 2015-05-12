#!/bin/bash
# Required scripts: edit-merge ssh-push ssh-valid func.ssh
# Description: join to the group which opject host is involved
# Usage: ssh-merge (user@host) ..
#   If no args, then hosts are picked up from authorized_keys
. func.getpar
mate=$(auth-mates) || _abort "No members"
valid=$(ssh-valid $mate) || _abort "No account valid"
ssh-join $valid
