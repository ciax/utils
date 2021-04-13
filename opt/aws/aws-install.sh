#!/bin/bash
mkdir -p ~/awstmp
cd ~/awstmp
if ! type aws; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    aws/install
fi
mkdir -p ~/.aws
cp ~/cfg.*/etc/aws/* ~/.aws
