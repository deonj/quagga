## Quagga Routing Suite on alpine:latest ##

This is the Quagga routing suite installed on Alpine linux. The daemons can be enabled/disabled from the /etc/quagga/daemons file. The following daemons are loaded by default:

* OSPF
* BGP

All other conf files are added in the /etc/quagga directory

## Example 1: Lab deployment ##

An isolated lab environment can be created. An example of a 3 router lab environment is shown in the topology below:

    +-----------+                 +-----------+               +-----------+
    |           |                 |           |               |           |
    |           |      Net1       |           |      Net2     |           |
    |  Router-1 +-----------------+  Router-2 +---------------+  Router-3 |
    |           |                 |           |               |           |
    |           |                 |           |               |           |
    +-----------+                 +-----------+               +-----------+

A docker-compose file can be created as follows:

    version: "3.8"
    services:
      rt1:
        container_name: router-1
        image: deonj/quagga
        networks:
          net1:
            ipv4_address: 192.168.1.20
        volumes:
          - router1-config:/etc/quagga
        tty: true
        restart:
          on-failure
      rt2:
        container_name: router-2
        image: deonj/quagga
        networks:
          net1:
            ipv4_address: 192.168.1.10
          net2:
            ipv4_address: 192.168.2.10
        volumes:
          - router2-config:/etc/quagga
        tty: true
        restart:
          on-failure
      rt3:
        container_name: router-3
        image: deonj/quagga
        networks:
          net2:
            ipv4_address: 192.168.2.20
        volumes:
          - router3-config:/etc/quagga
        restart:
          on-failure
        tty: true
       
    networks:
      net1:
        name: net1
        ipam:
          config:
            - subnet: "192.168.1.0/24"
      net2:
        name: net2
        ipam:
          config:
            - subnet: "192.168.2.0/24"
       
    volumes:
      router1-config:
      router2-config:
      router3-config:

The volumes are created if the user wants to backup the config files. The full topology can then be launched: 

    docker-compose up -d
    
**Note:** While the routing protocols will work, the data path wil not. This is because the Docker container automatically creates a default gateway which routes to the host for any external networks. This would mean that a ping from router 3 to router 1 will fail due to the ICMP routing to the host before it tries to reach router 1. If you find a way to remove the default gateway, I would like to know.

