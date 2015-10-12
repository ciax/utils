#!/bin/bash
# VPN disconnect after logout
vpn -d >/dev/null 2>&1
# UPDATE after logout
git-push >/dev/null 2>&1 &

