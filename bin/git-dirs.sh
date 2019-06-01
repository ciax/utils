#!/bin/bash
# Required scripts: func.dirs
# Description: dirlist that has .git
# Usate: git-dirs (-w:pushable repository) 
[ "$1" = -w ] && { shift;sb="/COMMIT_EDITMSG"; }
cd
. func.dirs
_exdir=gen2
_subdirs "[ -e .git$sb ] && ${@:-pwd -P}"
