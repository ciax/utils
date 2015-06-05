#!/bin/bash
shopt -s nullglob
for i in ~/bin/rc.logout.*;do
    source $i
done
