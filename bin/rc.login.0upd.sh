#!/bin/bash
# UPDATE before login
git-pullall
db-update
file-register ~/utils/bin
cfg-hosts -s
ssh-config -s

