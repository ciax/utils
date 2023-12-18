#!/bin/bash
# UPDATE before login
git-pullall
db-update
file-register
cfg-hosts -s
ssh-config -s

