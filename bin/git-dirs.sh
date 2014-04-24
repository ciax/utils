#!/bin/bash
# Required scripts: func.dirs
# Description: dirlist that has .git
. func.dirs
cd
_execdir '[ -d ".git" ] && pwd -P'
