#!/bin/bash
# VPN disconnect after logout
vpn -d
# UPDATE after logout
git-push
# Update ssh config
ssh-config -s
# Update file-register
file-register
