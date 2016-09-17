#!/bin/bash
# Reference: https://frillip.com/using-your-raspberry-pi-3-as-a-wifi-access-point-with-hostapd/
# Router Setting


IF=tun0
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
for IF in eth0 tun0; do
    sudo iptables -t nat -A POSTROUTING -o $IF -j MASQUERADE
    sudo iptables -A FORWARD -i $IF -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -A FORWARD -i wlan0 -o $IF -j ACCEPT
done
sudo systemctl restart dnsmasq
sudo /usr/sbin/hostapd -B /etc/hostapd/hostapd.conf

