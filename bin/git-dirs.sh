#!/bin/bash
# Required scripts: func.dirs
# Description: dirlist that has .git
cd
. func.dirs
_subdirs '[ -d ".git" ] && pwd -P'|grep -v gen2
