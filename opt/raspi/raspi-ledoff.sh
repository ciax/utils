#!/bin/bash
cfg-append <<EOF
#/boot/config.txt
disable_camera_led=1
EOF
echo "You need to reboot to take effect"
