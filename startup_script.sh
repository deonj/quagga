#!/bin/sh

set -e

# "Starting the zebra daemon"
/usr/sbin/zebra -d
# "Starting the ospf daemon"
/usr/sbin/ospfd -d
# "Starting the bgp daemon"
/usr/sbin/bgpd -d

# Delete default route
#command='ip route del default'
