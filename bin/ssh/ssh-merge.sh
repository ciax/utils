#!/bin/bash
# Description: join to the group which opject host is involved
# Required scripts: edit-merge, ssh-trim, ssh-valid
# Required packages: coreutils(cut,grep),diffutils(cmp),openssh-client(ssh,scp)
# Usage: ssh-merge (user@host) ..
#   If no args, then hosts are picked up from authorized_keys
ath=~/.ssh/authorized_keys
pub=~/.ssh/id_rsa.pub
read rs mykey me < $pub
ssh-join $(ssh-valid $(cut -d' ' -f3 $ath|grep @|grep -v $me)) 
