#!/bin/bash
# Reference: https://frillip.com/using-your-raspberry-pi-3-as-a-wifi-access-point-with-hostapd/
# diff -ur /etc .|grep -v Only > raspi_ap.patch
sudo patch -u -p0 -d /etc < ~/utils/opt/raspi/ap/raspi_ap.patch
