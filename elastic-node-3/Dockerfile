FROM elasticsearch:7.17.7
MAINTAINER atlas <web.dev89@yandex.by>

ENV VIRTUALHOST apache
ENV TZ Europe/Minsk

RUN apt update && apt -y upgrade \
    && apt install -y apt-transport-https gnupg2 default-jre-headless wget curl procps htop expect

# # #EXPOSE 80

# # #WORKDIR "/var/www"

COPY /ca-stack-cluster/elastic-stack-ca.p12 /usr/share/elasticsearch/config/cert/
COPY elastic-node-3/init/start.sh /usr/local/bin/start.sh
CMD /usr/local/bin/start.sh