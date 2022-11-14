FROM kibana:7.17.7

COPY ./kibana.yml /usr/share/kibana/config/
COPY test.sh /usr/local/bin/

RUN /usr/local/bin/test.sh