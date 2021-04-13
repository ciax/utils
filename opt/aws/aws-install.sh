#!/bin/bash
[ -d ~/awstmp ] || mkdir ~/awstmp
cd ~/awstmp
if ! type aws; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    aws/install
fi
[ -e aws-opt.ini ] || cp ~/cfg.*/etc/aws/aws-opt.ini .
