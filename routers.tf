# Доступ в интернет для машин БД
# Маршрутизатор
resource "vkcs_networking_router" "internet-gateway" {
  name                = "internet-gateway"
  external_network_id = data.vkcs_networking_network.extnet.id
  sdn                 = "sprut"
}
resource "vkcs_networking_router_interface" "db-internet" {
  router_id = vkcs_networking_router.internet-gateway.id
  subnet_id = vkcs_networking_subnet.dbcluster-subnet.id
}
# Его же используем для получения доступа к сети БД из сети управления
resource "vkcs_networking_router_interface" "control-internet" {
  router_id = vkcs_networking_router.internet-gateway.id
  subnet_id = vkcs_networking_subnet.control-subnet.id
}

# Создание продвинутух маршрутизаторов
# ГОЗНАК
resource "vkcs_dc_router" "zone1-dcrouter" {
  name = "zone1-dcrouter"
  availability_zone = var.zones["zone1"]
  }

# Медведково
resource "vkcs_dc_router" "zone2-dcrouter" {
  name              = "zone2-dcrouter"
  availability_zone = var.zones["zone2"]
}

# Коровинское 
resource "vkcs_dc_router" "zone3-dcrouter" {
  name              = "zone3-dcrouter"
  availability_zone = var.zones["zone3"]
}

# Подключение продвинутых маршрутизаторов к сетям
# Подключение к внешней сети
resource "vkcs_dc_interface" "zone1-dcr-ext-iface" {
  name         = "zone1-dcr-ext-iface"
  dc_router_id = vkcs_dc_router.zone1-dcrouter.id
  network_id   = data.vkcs_networking_network.extnet.id
}

resource "vkcs_dc_interface" "zone2-dcr-ext-iface" {
  name         = "zone2-dcr-ext-iface"
  dc_router_id = vkcs_dc_router.zone2-dcrouter.id
  network_id   = data.vkcs_networking_network.extnet.id
}

resource "vkcs_dc_interface" "zone3-dcr-ext-iface" {
  name         = "zone3-dcr-ext-iface"
  dc_router_id = vkcs_dc_router.zone3-dcrouter.id
  network_id   = data.vkcs_networking_network.extnet.id
}

# Подключение к внутренним сетям
# ГОЗНАК
resource "vkcs_dc_interface" "zone1-dcr-int-iface" {
  name         = "zone1-dcr-int-iface"
  ip_address   = "172.16.100.222"
  dc_router_id = vkcs_dc_router.zone1-dcrouter.id
  network_id   = vkcs_networking_network.DR_vnet.id
  subnet_id    = vkcs_networking_subnet.zone1-vnet100.id
}

resource "vkcs_dc_interface" "zone2-dcr-int-iface" {
  name         = "zone2-dcr-int-iface"
  ip_address   = "172.16.200.222"
  dc_router_id = vkcs_dc_router.zone2-dcrouter.id
  network_id   = vkcs_networking_network.DR_vnet.id
  subnet_id    = vkcs_networking_subnet.zone2-vnet200.id
}

resource "vkcs_dc_interface" "zone3-dcr-int-iface" {
  name         = "zone3-dcr-int-iface"
  ip_address   = "172.16.0.222"
  dc_router_id = vkcs_dc_router.zone3-dcrouter.id
  network_id   = vkcs_networking_network.DR_vnet.id
  subnet_id    = vkcs_networking_subnet.zone3-vnet000.id
}

#Подключение к сети управления
resource "vkcs_dc_interface" "zone1-dcr-control-iface" {
  name         = "zone1-dcr-control-iface"
  dc_router_id = vkcs_dc_router.zone1-dcrouter.id
  ip_address   = "172.16.10.201"
  network_id   = vkcs_networking_network.DR_vnet.id
  subnet_id    = vkcs_networking_subnet.control-subnet.id
}

resource "vkcs_dc_interface" "zone2-dcr-control-iface" {
  name         = "zone2-dcr-control-iface"
  dc_router_id = vkcs_dc_router.zone2-dcrouter.id
  ip_address   = "172.16.10.202"
  network_id   = vkcs_networking_network.DR_vnet.id
  subnet_id    = vkcs_networking_subnet.control-subnet.id
}

resource "vkcs_dc_interface" "zone3-dcr-control-iface" {
  name         = "zone3-dcr-control-iface"
  dc_router_id = vkcs_dc_router.zone3-dcrouter.id
  ip_address   = "172.16.10.203"
  network_id   = vkcs_networking_network.DR_vnet.id
  subnet_id    = vkcs_networking_subnet.control-subnet.id
}