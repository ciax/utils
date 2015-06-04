#!/bin/bash
shopt -s nullglob
for i in ~/bin/rc.login.*;do
    source $i
done
