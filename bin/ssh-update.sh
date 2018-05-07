#!/bin/bash
# Required scripts: ssh-join func.ssh
# Description: update partnership with all accounts listed in autholized_keys
# Usage: ssh-update (user@host) ..
#   If no args, then hosts are picked up from authorized_keys
. func.ssh
ssh-join $(_ssh_validate $(_ssh_auth_mates))
