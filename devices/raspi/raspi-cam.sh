#!/bin/bash
dir=/var/www/media
[ -d $dir ] || sudo mkdir -p $dir
fname=raspi$(date +%y%m%d-%H%M%S).jpg
sudo raspistill -o /var/www/media/$fname -w 640 -h 480

