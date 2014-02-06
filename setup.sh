#!/bin/bash --rcfile
cd ~/utils
for i in ./rc.*; do . $i;done
./register-files.sh
init-app