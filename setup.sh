#!/bin/bash --rcfile
cd ~/utils
for i in ./rc.*; do . $i;done
./reg-files.sh
pkg-deb init
