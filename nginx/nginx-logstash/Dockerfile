FROM nginx:latest
MAINTAINER atlas <web.dev89@yandex.by>

COPY nginx.conf /etc/nginx/nginx.conf
COPY mod-proxy-syslog.conf /etc/nginx/logstash-proxy/mod-proxy-syslog.conf

COPY logstash-connect.log /var/log/nginx/logstash/logstash-connect.log
COPY logstash-error.log /var/log/nginx/logstash/logstash-error.log