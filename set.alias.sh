#!/bin/bash
while read head name par; do
    file=$(realpath ${head%:*})
    alias $name="$file${par:+ $par}"
done < <(grep '^# *alias' ~/utils/*.sh)
