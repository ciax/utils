#!/bin/bash
# You need to join video group
[ -d ~/mmal ] || mkdir ~/mmal
sudo apt-get install motion libjpeg62-dev libavcodec-dev
sudo modprobe bcm2835-v4l2
cd ~/mmal
tar xvzf ~/utils/devices/raspi/motion-mmal.tar.gz
