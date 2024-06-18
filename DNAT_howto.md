## Работа с правилами DNAT на продвинутых маршрутизаторах

Прежде всего необходимо экспортировать в оболочку переменную окружения, содержащую токен доступа

Сам токен можно получить двумя способами:

1. В личном кабинете в разделе "Настройки проекта" - вкладка "Доступ по API"
2. Через **openstack cli**

Команда для получения токена доступа через **openstack cli**

```bash
openstack token issue -c id -f value
```

Производим экспорт переменной в оболочку

```bash
export OS_AUTH_TOKEN=YOUR_PROJECT_AUTH_TOKEN_HERE
```

### Получение списка правил DNAT

```bash
curl https://infra.mail.ru:35357/v3/direct_connect/dc_ip_port_forwardings \
--header "X-Auth-Token: $OS_AUTH_TOKEN" \
--header "Content-Type: text/plain"
```

### Создание правила DNAT

```bash
curl https://infra.mail.ru:35357/v3/direct_connect/dc_ip_port_forwardings \
--header "X-Auth-Token: $OS_AUTH_TOKEN" \
--header "Content-Type: text/plain" \
--data '{ 
 "dc_ip_port_forwarding": {  
  "name": "Test_http",
  "description": "Test Description",  
  "dc_interface_id": "UUID-OF-ADVANCED-ROUTER-PORT",
  "protocol": "tcp",
  "destination": "IP-OF-ADVANCED-ROUTER-PORT",   
  "port": 80,
  "to_port": 80,   
  "to_destination": "IP-OF-DESTINATION-HOST"
  }
}'
```

Пояснения по параметрам вызова:

- **dc_interface_id** - id интерфейса продвинутого роутера, на который приходит внешний трафик
- **destination** - ip-адрес интерфейса продвинутого роутера, на который приходит внешний трафик (может быть VIP-адресом)
- **to_destination** - ip-адрес целевого хоста, куда будет перенаправлен трафик

### Удаление правила DNAT

```bash
curl -X DELETE https://infra.mail.ru:35357/v3/direct_connect/dc_ip_port_forwardings/UUID_OF_PORT_FORWARDING_RULE \
--header "X-Auth-Token: $OS_AUTH_TOKEN"
```

ID правила DNAT можно получить из вывода списка правил DNAT. Требуемое значение содержится в поле **id** объекта списка **dc_ip_port_forwardings**
