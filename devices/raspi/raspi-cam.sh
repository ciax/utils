#!/bin/bash
fname=raspi$(date +%y%m%d-%H%M%S).jpg
sudo raspistill -o /var/www/media/$fname -w 640 -h 480

