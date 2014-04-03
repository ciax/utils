#!/bin/bash
# Required commands: cut,grep,cmp,ssh,scp
# Required scripts: edit-merge, ssh-trim, ssh-valid
# Description: join to the group which opject host is involved
# Usage: ssh-merge (user@host) ..
#   If no args, then hosts are picked up from authorized_keys
ath=~/.ssh/authorized_keys
pub=~/.ssh/id_rsa.pub
read rs mykey me < $pub
ssh-join $(ssh-valid $(cut -d' ' -f3 $ath|grep @|grep -v $me)) 
