#!/bin/bash
# Reference: https://frillip.com/using-your-raspberry-pi-3-as-a-wifi-access-point-with-hostapd/
# Router Setting
# Required packages: dnsmasq
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
pidof hostapd || sudo /usr/sbin/hostapd -B /etc/hostapd/hostapd.conf
sudo systemctl restart dnsmasq
sudo iptables -t nat -F
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#    sudo iptables -A FORWARD -i $IF -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
#    sudo iptables -A FORWARD -i wlan0 -o $IF -j ACCEPT

