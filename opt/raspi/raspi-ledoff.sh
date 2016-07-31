#!/bin/bash
cfg-append <<EOF
#file /boot/config.txt
disable_camera_led=1
EOF
echo "You need to reboot to take effect"
