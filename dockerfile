FROM alpine:latest
RUN apk update
RUN apk --no-cache add quagga openrc busybox-extras
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
RUN sed -i "s/!hostname/hostname/" vtysh.conf
RUN sed -i "s/!username/username/" vtysh.conf
RUN chown quagga *.conf
RUN rc-update add zebra
RUN rc-update add ospfd
RUN rc-update add bgpd
RUN rc-service zebra start
RUN rc-service ospfd start
RUN rc-service bgpd start
