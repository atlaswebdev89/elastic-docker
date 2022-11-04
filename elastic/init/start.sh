#!/usr/bin/env bash

# Правильный часовой пояс
tz=$TZ;
if [[ -n $tz ]];
then 
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

/usr/share/elasticsearch/bin/elasticsearch-certutil cert --ca /usr/share/elasticsearch/config/cert/elastic-stack-ca.p12










# Запуст команды из под пользователя elasticsearch
su elasticsearch -c /usr/share/elasticsearch/bin/elasticsearch




