#!/bin/bash
#Required packages: open-vm-tools kernel-package linux-libc-dev
. func.getpar
cd
sudo mount /dev/cdrom /media/cdrom0 || _abort "Can't mount cdrom"
file=/media/cdrom0/VM*
[ -s $file ] || _abort "No install file"
# expand file
tar xvzf $file
sudo umount /media/cdrom0
# install headers
pkg getheader || exit 1
# Apply patchies
git clone https://github.com/rasa/vmware-tools-patches.git
cd vmware-tools-patches
./download-tools.sh 6.0.2 # VMware workstation 10.0.1
./untar-and-patch.sh
# install vmware tools
./compile.sh
#sudo vmware-tools-distrib/vmware-install.pl
