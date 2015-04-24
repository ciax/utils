#!/bin/bash
# You need to join video group
[ -d ~/mmal ] || mkdir ~/mmal
sudo apt-get install motion libjpeg62-dev libavcodec-dev
sudo ln -s /usr/lib/arm-linux-gnueabihf /usr/lib64
sudo modprobe bcm2835-v4l2
git clone https://github.com/dozencrows/motion.git
cd ~/motion
./configure
make
sudo make install

