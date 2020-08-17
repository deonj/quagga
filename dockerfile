FROM alpine:latest
RUN apk update
RUN apk add --no-cache quagga busybox-extras
WORKDIR /etc/quagga
RUN touch daemons
RUN echo 'zebra=yes' >> daemons
RUN echo 'ospfd=yes' >> daemons
RUN echo 'bgpd=yes' >> daemons
RUN wget https://raw.githubusercontent.com/deonj/quagga/master/zebra.conf
RUN wget https://raw.githubusercontent.com/deonj/quagga/master/vtysh.conf
RUN wget https://raw.githubusercontent.com/deonj/quagga/master/ospfd.conf
RUN wget https://raw.githubusercontent.com/deonj/quagga/master/bgpd.conf
RUN wget https://raw.githubusercontent.com/deonj/quagga/master/sample_conf/ospf6d.conf.sample
RUN wget https://raw.githubusercontent.com/deonj/quagga/master/sample_conf/ripd.conf.sample
RUN wget https://raw.githubusercontent.com/deonj/quagga/master/sample_conf/ripngd.conf.sample
RUN wget -P /opt/ https://raw.githubusercontent.com/deonj/quagga/master/startup_script.sh
RUN chmod 744 /opt/startup_script.sh
RUN sed -i "s/!hostname/hostname/" vtysh.conf
RUN sed -i "s/!username/username/" vtysh.conf
RUN chown quagga *.conf
RUN echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
RUN echo "net.ipv4.conf.all.forwarding=1" >> /etc/sysctl.conf
RUN echo "net.ipv4.conf.default.forwarding=1" >> /etc/sysctl.conf
RUN echo "net.ipv4.conf.all.mc_forwarding=1" >> /etc/sysctl.conf
RUN echo "net.ipv4.conf.default.mc_forwarding=1" >> /etc/sysctl.conf
RUN echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
RUN echo "net.ipv6.conf.default.forwarding=1" >> /etc/sysctl.conf
RUN echo "net.ipv6.conf.default.router_solicitations = 1" >> /etc/sysctl.conf
ENTRYPOINT ["/bin/sh", "-c", "/opt/startup_script.sh; sh"]
