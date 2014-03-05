#!/bin/bash
complete -r
for i in ~/bin/rc.*; do . $i;done
. set.alias
