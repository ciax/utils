#!/bin/bash
complete -r
for i in ~/utils/rc.*; do . $i;done
. set.alias
