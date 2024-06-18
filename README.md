
# Типовая инфраструктура отказоустойчивого web-приложения

Репозиторий содержит набор манифестов Terraform для развертывания отказоустойчивой высокодоступной инфраструктуры типового web-приложения в VK Cloud.

### Какие ресурсы создаются с помощью манифестов Terraform

В **каждой из зон доступности**:

- [Продвинутый облачный маршрутизатор](https://cloud.vk.com/docs/ru/networks/vnet/concepts/router#vozmozhnosti_prodvinutogo_marshrutizatora)
- ВМ-участник кластера БД
- ВМ для back части web-приложения
- ВМ для front части web-приложения
- ВМ для сервиса мониторинга доступности приложения и управления DNS записями
- [Облачный балансировщик нагрузки](https://cloud.vk.com/docs/ru/networks/balancing)

В **одной из зон доступности** создаётся jump-сервер для задач эксплуатации web-приложения.

### Подготовка окружения Terraform

1. [Установка Terraform и его конфигурирование для работы с VK Cloud](https://cloud.vk.com/docs/ru/tools-for-using-services/terraform/quick-start)

2. В директории со склонированным репозиторием создаем файл **creds.auto.tfvars** и наполняем его следующим содержимым:

    ```text
    provider_auth_url = "https://infra.mail.ru:35357/v3/"
    provider_username = "< Логин пользователя VK Cloud >"
    provider_password = "< Пароль пользователя VK Cloud >"
    provider_project  = "< ID проекта со страницы настроек проекта (вкладка Terraform) в ЛК >"
    key_pair_name     = "< Название ключевой пары SSH из настроек проекта в ЛК >"
    ```

3. Репозиторий содержит файл **vkcs_provider.tf** в котором обычно менять ничего не нужно, но если требуется конкретная версия terraform провайдера, то можно указать её в блоке *terraform {}* в параметре **version**:

    ```text
    terraform {
      required_providers {
        vkcs = {
          source = "vk-cs/vkcs"
          version = "~> 0.7.4"
        }
      }
    }

    provider "vkcs" {
      username   = var.provider_username
      password   = var.provider_password
      project_id = var.provider_project
      region     = "RegionOne"
      auth_url   = var.provider_auth_url
    }
    ```

4. Репозиторий содержит файл **zones.auto.tfvars** со списком зон доступности VK Cloud, в которых будут развернуты ВМ, продвинутые маршрутизаторы и балансировщики нагрузки:

    ```text
    zones = {
        "zone1" = "GZ1"
        "zone2" = "ME1"
        "zone3" = "MS1"
    }
    ```

5. В файле **flavors.auto.tfvars** указаны флейворы, которые будут использованы при разворачивании ВМ:

    ```text
    db_flavor = "STD3-2-4"
    back_flavor = "STD3-2-2"
    front_flavor = "STD3-2-2"
    dns_wd_flavor = "STD3-2-2"
    ```

## Использование

В каталоге с репозиторием после подготовки окружения выполняем следующие шаги:

1. Инициализация

    ```bash
    terraform init
    ```

2. Для ознакомления со списком изменений, которые будут применены во время выполнения манифеста

    ```bash
    terraform plan
    ```

3. Для применения изменений в проекте

    ```bash
    terraform apply
    ```

## Дальнейшие шаги (предполагаемое использование)

1) Разворачивание на ВМ с именами zone1-db, zone2-db, zone3-db отказоусточивого кластера СУБД (PostgreSQL + Patroni + Virtual IP Manager)
2) Разворачивание back части web-приложения на ВМ с именами zone(1,2,3)-back
3) Разворачивание front части web-приложения на ВМ с именами front(1,2,3)-back
4) Настройка [DNAT](https://cloud.vk.com/docs/networks/vnet/concepts/router#vozmozhnosti_prodvinutogo_marshrutizatora) на продвинутых маршрутизаторах с пренаправлением трафика на облачный балансировщик нагрузки в той же зоне доступности
5) Настройка на ВМ zone(1,2,3)-dns-watchdog сервиса для мониторинга доступности web-приложения на публичных IP-адресах и управления А записями в сервисе DNS проекта VK Cloud.

## Примечания

- [Документация по Terraform в VK Cloud](https://cloud.vk.com/docs/tools-for-using-services/terraform)
- [Примеры добавления DNAT правил через API VK Cloud](https://github.com/vk-cs/cloud-refarch/blob/master/DNAT_howto.md)
