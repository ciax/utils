#!/bin/bash
# Description: Install GitHub App
target="/mtdmn/beautify_bash $*"
mkdir -p ~/app
cd ~/app
for i in $target; do
   git clone https://github.com$i.git
done
file-perm
file-register .

