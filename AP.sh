#!/bin/bash
ifconfig wlan0 down
macchanger -r wlan0
iwconfig wlan0 mode monitor
ifconfig wlan0 up 192.168.1.1 netmask 255.255.255.0
airmon-ng check kill
service dnsmasq stop
dnsmasq -C /etc/dnsmasq.conf -d > /var/log/dnsmasq.log &
hostapd /etc/hostapd/hostapd.conf > /var/log/hostapd.log &
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
iptables --append FORWARD --in-interface wlan0 -j ACCEPT
echo 1 > /proc/sys/net/ipv4/ip_forward
