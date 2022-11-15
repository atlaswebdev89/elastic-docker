#!/usr/bin/env bash

# Правильный часовой пояс
tz=$TZ;
if [[ -n $tz ]];
then 
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

# Настраиваются сертификаты доступа 
if ! [[ -z ${SECURITY} ]] && [[ ${SECURITY} == "true" ]]
then

	# Проверяем есть ли сертификат. Если есть нечего не делаем. Если нет создаем новый сертификат
	if ! [[ -f /usr/share/elasticsearch/config/elastic-certificates.p12 ]]
	then
				# Проверяем наличие корневого сертификата. Если нету, то будет ошибка и контейнер не запуститься
				if [[ -f /usr/share/elasticsearch/config/cert/elastic-stack-ca.p12 ]]
				then
					cp /usr/share/elasticsearch/config/cert/elastic-stack-ca.p12 /usr/share/elasticsearch/config/elastic-stack-ca.p12
					# создаем сертификат для ноды elastic без пароля. Нечего в keystore добавлять не надо
					/usr/share/elasticsearch/bin/elasticsearch-certutil cert --ca /usr/share/elasticsearch/config/elastic-stack-ca.p12 --ca-pass '' --out /usr/share/elasticsearch/config/elastic-certificates.p12 --pass ''
					# Изменяем права доступа к сертификатам
					chmod 775 /usr/share/elasticsearch/config/elastic-certificates.p12
					chmod 775 /usr/share/elasticsearch/config/elastic-stack-ca.p12
					echo "Setup minimal security. Certificates done!"
				else 
					echo "Not found ca certificate. You need run script init-ca-cert.sh!!"
					exit 1	
				fi
	fi
fi

# Формирование конфигаруционного файла для Elasticsearch
if  [[ -z $CLUSTER_NAME ]]; then
    CLUSTER_NAME=node-elastic-1
fi


cat << EOF > /usr/share/elasticsearch/config/elasticsearch.yml
# ======================== Elasticsearch Configuration =========================
            cluster.name: $CLUSTER_NAME
            node.name: $NODE_NAME
            node.roles: $NODE_ROLES
            network.host: $NETWORK_HOST
            http.port: $HTTP_PORT
            transport.host: $TRANSPORT_HOSTS
            transport.tcp.port: $TRANSPORT_TCP_PORT
            discovery.seed_hosts: $DISCOVERY_SEED_HOSTS
            cluster.initial_master_nodes: $CLUSTER_INITIAL_MASTER_NODES
EOF
# Бесконечный цикл

if ! [[ -z $SECURITY ]]  && [[ $SECURITY==true ]]; then
cat << EOF >> /usr/share/elasticsearch/config/elasticsearch.yml
            # Защита настраивается когда в enviroments задана переменная SECURITY. Если она не указана это секция не нужна
            xpack.security.enabled: true
            xpack.security.transport.ssl.enabled: true
            xpack.security.transport.ssl.verification_mode: certificate
            xpack.security.transport.ssl.client_authentication: required
            xpack.security.transport.ssl.keystore.path: elastic-certificates.p12
            xpack.security.transport.ssl.truststore.path: elastic-stack-ca.p12 
            # Без этой настройки не работают оповещения в elastic
            xpack.security.authc.api_key.enabled: true
EOF
fi


if [[ -f /usr/share/elasticsearch/config/elasticsearch.yml ]]; then
    chown elasticsearch:elasticsearch /usr/share/elasticsearch/config/elasticsearch.yml
else 
    echo "File elasticsearch.yml not found";
	exit 0;
fi


# Запуст команды из под пользователя elasticsearch
su elasticsearch -c /usr/share/elasticsearch/bin/elasticsearch 