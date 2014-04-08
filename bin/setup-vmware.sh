#!/bin/bash
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
# install vmware tools
sudo vmware-tools-distrib/vmware-install.pl
