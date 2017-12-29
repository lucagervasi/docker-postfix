FROM alpine:3.7

RUN echo @edge http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories 

RUN apk --update --nocache add supervisor postfix opendkim postfix-policyd-spf-perl postgrey

RUN mkdir /etc/supervisor.d/

RUN mkdir -p /run/opendkim && chown opendkim /run/opendkim

ADD supervisor.d/opendkim.ini /etc/supervisor.d/opendkim.ini 
ADD supervisor.d/postgrey.ini /etc/supervisor.d/postgrey.ini 
ADD supervisor.d/postfix.ini /etc/supervisor.d/postfix.ini 

VOLUME /var/db/dkim
VOLUME /etc/postfix
VOLUME /etc/opendkim

EXPOSE 25
EXPOSE 587
