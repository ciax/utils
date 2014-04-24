#!/bin/bash
# Required scripts: rec-dirs
# Description: dirlist that has .git
cd
rec-dirs '[ -d ".git" ] && pwd -P'
