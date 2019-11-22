#!/bin/bash
#
# This version uses September 2017 august stretch image, please use this image
#

if [ "$EUID" -ne 0 ]
	then echo "Must be root"
	exit
fi

if [[ $# -gt 1 ]]; 
	then echo "You need to pass a password!"
	echo "Usage:"
	echo "sudo $0 [apName]"
	exit
fi

APSSID="rPi3"

if [[ $# -eq 2 ]]; then
	APSSID=$1
fi

apt-get remove --purge hostapd -yqq
apt-get update -yqq
apt-get upgrade -yqq
apt-get install hostapd dnsmasq -yqq

cat > /etc/dnsmasq.conf <<EOF
interface=wlan0
dhcp-range=192.168.4.50,192.168.4.100,255.255.255.0,12h
EOF

cat > /etc/hostapd/hostapd.conf <<EOF
interface=wlan0
hw_mode=g
channel=10
auth_algs=1
rsn_pairwise=CCMP
ssid=$APSSID
ieee80211n=1
wmm_enabled=1
ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]
EOF

sed -i -- 's/#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd

echo "denyinterfaces wlan0" >> /etc/dhcpcd.conf

systemctl unmask hostapd
systemctl enable hostapd
systemctl enable dnsmasq

service hostapd start
service dnsmasq start

# Bridge the interfaces
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE
iptables-save > /etc/iptables.ipv4.nat
echo "iptables-restore < /etc/iptables.ipv4.nat" >> /etc/rc.local

echo "All done! Please reboot"
