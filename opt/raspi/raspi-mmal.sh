#!/bin/bash
# You need to join video group
[ -d ~/mmal ] || mkdir ~/mmal
cd ~/mmal
sudo ./motion -n -c motion.conf &
