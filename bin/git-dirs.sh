#!/bin/bash
# Required scripts: func.dirs
# Description: dirlist that has .git
cd
. func.dirs
_exdir=gen2
_subdirs '[ -d ".git" ] && pwd -P'
