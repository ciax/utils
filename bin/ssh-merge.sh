#!/bin/bash
# Required scripts: ssh-join func.ssh
# Description: join to the group which opject host is involved
# Usage: ssh-merge (user@host) ..
#   If no args, then hosts are picked up from authorized_keys
. func.ssh
ssh-join $(_ssh-validate $(_ssh-auth-mates))
