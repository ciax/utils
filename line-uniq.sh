#!/bin/bash
# Required script: usage.sh
# Required packages: coreutils(sort,nkf)
# Remove duplicated lines
#alias unq
[ -t 0 ] && . func.usage " < [files]"
nkf -d|sort -u
