#!/bin/bash
git-pushall
db-update
ssh-config -s
cfg-hosts -s
file-register
