## Quagga Routing Suite on alpine:latest ##

This is the Quagga routing suite installed on Alpine linux. The daemons can be enabled/disabled from the /etc/quagga/daemons file. The following daemons are loaded by default:

* OSPF
* BGP

All other conf files are added in the /etc/quagga directory

## Example ##

To create a network of routers as shown in topology below:

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
          - net1
        volumes:
          - router1-config:/etc/quagga
        tty: true
        restart:
          on-failure
      rt2:
        container_name: router-2
        image: deonj/quagga
        networks:
          - net1
          - net2
        volumes:
          - router2-config:/etc/quagga
        tty: true
        restart:
          on-failure
      rt3:
        container_name: router-3
        image: deonj/quagga
        networks:
          - net2
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

The full topology can then be launched: **docker-compose up -d**
The routers can now be configured individually.
