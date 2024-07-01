#!/usr/bin/env bash
# OneDrive(Debian) UnInstaller

# Remove Old Packages
sudo apt remove onedrive
sudo add-apt-repository --remove ppa:yann1ck/onedrive

# Update System
sudo rm -rf /var/lib/dpkg/lock-frontend
sudo rm -rf /var/lib/dpkg/lock
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean -y

#reboot
