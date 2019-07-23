#!/bin/bash

#set up eth0 with static address:

cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=manual
IPADDR=192.168.122.85
NETWORK=192.168.122.0
NETMASK=255.255.255.0
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=eth0
UUID=877b4e0d-f4d5-438b-9962-55ad2c04684d
DEVICE=eth0
ONBOOT=yes
EOF


#add static defaultgw:

cat << EOF > /etc/sysconfig/network
GATEWAY=192.168.122.1
EOF

#set static DNS:
cat << EOF > /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
search localdomain
EOF
