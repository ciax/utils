#!/bin/bash
# Required script: usage.sh
# Required packages: coreutils(sort,nkf)
# Remove duplicated lines
#alias unq
[ -t 0 ] && . set.usage " < [files]"
nkf -d|sort -u
