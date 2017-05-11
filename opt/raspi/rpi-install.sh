#!/bin/bash
cd
sudo apt-get update
sudo apt-get dist-upgrade
sudo rpi-update
git clone https://github.com/silvanmelchior/RPi_Cam_Web_Interface.git
cd RPi_Cam_Web_Interface
file-perm
./install.sh
