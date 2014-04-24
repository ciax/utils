#!/bin/bash
# Description: show dependent scripts
cd ~/bin
for share in *;do
    for use in $(grep -l "$share" *);do
        [ "$use" = "$share" ] || echo "$use $share"
    done
done
