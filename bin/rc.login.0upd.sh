#!/bin/bash
# UPDATE before login
git-pullall
db-update
file-register
hosts -s
ssh-config -s

