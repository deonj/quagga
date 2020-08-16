#!/bin/sh

# "Starting the zebra daemon"
command="/usr/sbin/zebra -d"
# "Starting the ospf daemon"
command="/usr/sbin/ospfd -d"
# "Starting the bgp daemon"
command="/usr/sbin/bgpd -d"

# Delete default route
ip route del default
