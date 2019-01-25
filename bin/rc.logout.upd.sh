#!/bin/bash
# VPN disconnect after logout
vpn -d >/dev/null 2>&1
# UPDATE after logout
git-push >/dev/null 2>&1 &
# Update ssh config
ssh-config -s >/dev/null 2>&1 &
# Update file-register
file-register >/dev/null 2>&1 &
