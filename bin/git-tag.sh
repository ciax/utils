#!/bin/bash
# Description: add tag
#alias gtag
[ "$1" ] || { echo "Usage: git-tag [tag]"; git tag; exit 1; }
msg="[$1] at $(hostname) / $(date)"
tag="$1@$(date +%Y%m%d)/$(hostname)"
git tag -afm "$msg" "$tag"
# >/dev/null 2>&1
