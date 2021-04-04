FROM alpine:latest
RUN apk add squid openssl
RUN cd /etc/squid
RUN mkdir ssl_cert
RUN chown squid:squid ssl_cert
RUN chmod 700 ssl_cert
RUN cd ssl_cert
RUN /usr/lib/squid/security_file_certgen -c -s /var/lib/ssl_db -M 4MB
RUN chown squid:squid -R /var/lib/ssl_db