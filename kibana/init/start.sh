#!/usr/bin/env bash

# Формирование конфигаруционного файла для Elasticsearch
# Пока без проверок... Потом допишим!!!

cat << EOF > /usr/share/kibana/config/kibana.yml
                server.port: 5601
                server.host: 0.0.0.0
                # Блок настроек если используется защита в elastic. Переменная SECURITY в установлена в true
                xpack.security.enabled: true
                elasticsearch.username: ${USER_NAME}
                elasticsearch.password: ${PASSWORD}
                server.publicBaseUrl: "http://${PUBLIC_BASE_URL}"
                elasticsearch.hosts:
                    - http://${ELASTIC_HOST}:9200
                    - http://${ELASTIC_HOST_SECONDORY}:9200
                # Для настройки оповещения
                xpack.security.encryptionKey: "ThisIsToTestTheWazuhXpackSecuirtyTesting000"
                xpack.reporting.encryptionKey: "something_at_least_32_characters"
                xpack.encryptedSavedObjects.encryptionKey: "something_at_least_32_characters"
EOF

chown  kibana:kibana /usr/share/kibana/config/kibana.yml

# Запускаем kibana
/usr/share/kibana/bin/kibana