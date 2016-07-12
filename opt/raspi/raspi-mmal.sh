#!/bin/bash
# You need to join video group
[ -d ~/mmal ] || mkdir ~/mmal
cd ~/mmal
sudo ./motion -c motion-mmalcam-both.conf > ~/.var/mmal.log 2>&1 &
