FROM alpine:latest
RUN apk update
RUN apk --no-cache add quagga supervisor busybox-extras
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
RUN wget https://raw.githubusercontent.com/deonj/quagga/master/supervisord.conf
RUN sed -i "s/!hostname/hostname/" vtysh.conf
RUN sed -i "s/!username/username/" vtysh.conf
RUN chown quagga *.conf
RUN mv -f supervisord.conf /etc
RUN echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
RUN echo "net.ipv4.conf.all.forwarding=1" >> /etc/sysctl.conf
RUN echo "net.ipv4.conf.default.forwarding=1" >> /etc/sysctl.conf
RUN echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
RUN echo "net.ipv6.conf.default.forwarding=1" >> /etc/sysctl.conf
RUN echo "net.ipv4.conf.all.mc_forwarding=1" >> /etc/sysctl.conf
RUN echo "net.ipv4.conf.default.mc_forwarding=1" >> /etc/sysctl.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
