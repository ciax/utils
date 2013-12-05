#!/bin/bash
trp="rm -f -- "
for i ; do
    tmp=$(tempfile)
    trp="$trp $tmp"
    eval "$i=$tmp"
done
trap "$trp" EXIT
unset i trp tmp