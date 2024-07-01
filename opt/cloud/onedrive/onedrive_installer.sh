#!/usr/bin/env bash
# OneDrive(Debian12) Installer
# Reference: https://github.com/abraunegg/onedrive/tree/master

# Download Package Source List
wget -qO - https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_12/Release.key | gpg --dearmor | sudo tee /usr/share/keyrings/obs-onedrive.gpg > /dev/null

# Add repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/obs-onedrive.gpg] https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/Debian_12/ ./" | sudo tee /etc/apt/sources.list.d/onedrive.list

# Update apt-get
sudo apt-get update

# Install Onedrive
sudo apt install --no-install-recommends --no-install-suggests onedrive
