#!/bin/bash
# Description: list the mate accounts in authorized_keys
# Usage: ssh-mates
ath=~/.ssh/authorized_keys
pub=~/.ssh/id_rsa.pub
read rs mykey me < $pub
cut -d' ' -f3 $ath|grep @|grep -v $me
