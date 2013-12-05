#!/bin/bash
trp="rm -f -- "
for i ; do
    tmp=$(tempfile) || { echo "Can't make mktemp"; exit 1; }
    trp="$trp $tmp"
    eval "$i=$tmp"
done
trap "$trp" EXIT
unset i trp tmp