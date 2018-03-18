FROM alpine:3.7

RUN echo @edge http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories

RUN apk --update --no-cache upgrade
RUN apk --update --no-cache add \
    supervisor \
    postfix \
    opendkim \
    postfix-policyd-spf-perl \
    postgrey \
    postfix-pcre \
    postfix-sqlite \
    cyrus-sasl \
    cyrus-sasl-digestmd5 \
    cyrus-sasl-crammd5

RUN rm -rf /tmp/* /tmp/.* /var/cache/apk/* || true
RUN mkdir /etc/supervisor.d/

RUN mkdir -p /run/opendkim && chown opendkim /run/opendkim

ADD supervisor.d/opendkim.ini /etc/supervisor.d/opendkim.ini
ADD supervisor.d/postgrey.ini /etc/supervisor.d/postgrey.ini
ADD supervisor.d/postfix.ini  /etc/supervisor.d/postfix.ini
ADD supervisor.d/syslogd.ini  /etc/supervisor.d/syslogd.ini

ADD supervisord.conf /etc/supervisord.conf
ADD syslog.conf /etc/syslog.conf

VOLUME /etc/postfix
VOLUME /run/opendkim

EXPOSE 25
EXPOSE 587

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
