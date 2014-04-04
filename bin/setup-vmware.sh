#!/bin/bash
. func.app
cd
sudo mount /dev/cdrom /media/cdrom0
file=/media/cdrom0/VM*
[ -s "$file" ] || _abort "No install file"
# expand file
tar xvzf $file
sudo umount /media/cdrom0
# install headers
sudo apt-get install linux-headers-$(uname -r)
# install vmware tools
sudo vmware-tools-distrib/vmware-install.pl
