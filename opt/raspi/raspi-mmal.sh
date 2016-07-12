#!/bin/bash
# You need to join video group
[ -d ~/mmal ] || mkdir ~/mmal
cd ~/mmal
sudo ./motion -c motion.conf > ~/.var/mmal.log 2>&1 &
