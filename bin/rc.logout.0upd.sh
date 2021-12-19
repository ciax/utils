#!/bin/bash
git-pushall
db-update
ssh-config -s
hosts -s
file-register
