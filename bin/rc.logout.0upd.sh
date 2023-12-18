#!/bin/bash
# Update after logout
git-pushall
db-update
ssh-config -s
cfg-hosts -s
file-register
