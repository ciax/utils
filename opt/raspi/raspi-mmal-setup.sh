#!/bin/bash
# For Raspbian JESSIE
# Refered to: http://wiki.raspberrytorte.com/index.php?title=Motion_MMAL
[ -d ~/mmal ] || mkdir ~/mmal
cd ~/mmal
sudo apt-get install -y libjpeg-dev libavformat56 libavformat-dev libavcodec56 libavcodec-dev libavutil54 libavutil-dev libc6-dev zlib1g-dev libmysqlclient18 libmysqlclient-dev libpq5 libpq-dev
wget https://www.dropbox.com/s/6ruqgv1h65zufr6/motion-mmal-lowflyerUK-20151114.tar.gz
tar -zxvf motion-mmal-lowflyerUK-20151114.tar.gz

