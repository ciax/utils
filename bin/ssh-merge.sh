#!/bin/bash
# Required scripts: edit-merge ssh-push ssh-valid func.ssh
# Description: join to the group which opject host is involved
# Usage: ssh-merge (user@host) ..
#   If no args, then hosts are picked up from authorized_keys
set -e
. func.ssh
ssh-join $(_rem-valid $(_auth-mates))
