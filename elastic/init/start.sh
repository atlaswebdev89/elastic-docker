#!/usr/bin/env bash

# Правильный часовой пояс
tz=$TZ;
if [[ -n $tz ]];
then 
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi
# Запуст команды из под пользователя elasticsearch
su elasticsearch -c /usr/share/elasticsearch/bin/elasticsearch



