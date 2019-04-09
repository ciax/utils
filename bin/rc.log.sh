#!/bin/bash
# Log (in/out) boot strap
#link rc.login
#link rc.logout
shopt -s nullglob
date
for i in $0.*;do
    source $i
done
