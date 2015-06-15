#!/bin/bash
text-append <<EOF
#/boot/config.txt
disable_camera_led=1
EOF
echo "You need to reboot to take effect"
