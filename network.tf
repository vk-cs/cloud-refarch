data "vkcs_networking_network" "extnet" {
  name = "internet"
}

# Создаём сеть для размещения инфраструктурных ВМ
resource "vkcs_networking_network" "DR_vnet" {
  name = "DR_vnet"
  sdn  = "sprut"
}

# Виртуальная подсеть для машин в ГОЗНАК
resource "vkcs_networking_subnet" "zone1-vnet100" {
  name       = "zone1-vnet100"
  network_id = vkcs_networking_network.DR_vnet.id
  cidr       = "172.16.100.0/24"
  gateway_ip = "172.16.100.1"
  sdn        = "sprut"
}

# Виртуальная подсеть для машин в Медведково
resource "vkcs_networking_subnet" "zone2-vnet200" {
  name       = "zone2-vnet200"
  network_id = vkcs_networking_network.DR_vnet.id
  cidr       = "172.16.200.0/24"
  gateway_ip = "172.16.200.1"
  sdn        = "sprut"
}

# Виртуальная подсеть для машин на Коровинское ш.
resource "vkcs_networking_subnet" "zone3-vnet000" {
  name       = "zone3-vnet000"
  network_id = vkcs_networking_network.DR_vnet.id
  cidr       = "172.16.0.0/24"
  gateway_ip = "172.16.0.1"
  sdn        = "sprut"
}

# Создаём сеть для БД
resource "vkcs_networking_network" "dbcluster-net" {
  name = "dbcluster-Network"
  sdn  = "sprut"
}
resource "vkcs_networking_subnet" "dbcluster-subnet" {
  name       = "dbcluster-subnet"
  cidr       = "172.16.50.0/24"
  gateway_ip = "172.16.50.1"
  network_id = vkcs_networking_network.dbcluster-net.id
  sdn        = "sprut"
}

# Обходное решение: разделяем 0.0.0.0/0 на два сегмента, направляем в Advanced Router
# ГОЗНАК
resource "vkcs_networking_subnet_route" "zone1-sub_route_0" {
  subnet_id        = vkcs_networking_subnet.zone1-vnet100.id
  destination_cidr = "0.0.0.0/1"
  next_hop         = "172.16.100.222"
}
resource "vkcs_networking_subnet_route" "zone1-sub_route_128" {
  subnet_id        = vkcs_networking_subnet.zone1-vnet100.id
  destination_cidr = "128.0.0.0/1"
  next_hop         = "172.16.100.222"
}

# Медведково
resource "vkcs_networking_subnet_route" "zone2-sub_route_0" {
  subnet_id        = vkcs_networking_subnet.zone2-vnet200.id
  destination_cidr = "0.0.0.0/1"
  next_hop         = "172.16.200.222"
}
resource "vkcs_networking_subnet_route" "zone2-sub_route_128" {
  subnet_id        = vkcs_networking_subnet.zone2-vnet200.id
  destination_cidr = "128.0.0.0/1"
  next_hop         = "172.16.200.222"
}

# Коровинское ш.
resource "vkcs_networking_subnet_route" "zone3-sub_route_0" {
  subnet_id        = vkcs_networking_subnet.zone3-vnet000.id
  destination_cidr = "0.0.0.0/1"
  next_hop         = "172.16.0.222"
}
resource "vkcs_networking_subnet_route" "zone3-sub_route_128" {
  subnet_id        = vkcs_networking_subnet.zone3-vnet000.id
  destination_cidr = "128.0.0.0/1"
  next_hop         = "172.16.0.222"
}

# Создание сети управления
resource "vkcs_networking_subnet" "control-subnet" {
  name       = "control-subnet"
  network_id = vkcs_networking_network.DR_vnet.id
  cidr       = "172.16.10.0/24"
  gateway_ip = "172.16.10.1"
  sdn        = "sprut"
}

#Маршруты из подсети управления в подсети на разных площадках
#В ГОЗНАК
resource "vkcs_networking_subnet_route" "route-contol-zone1" {
  subnet_id        = vkcs_networking_subnet.control-subnet.id
  destination_cidr = "172.16.100.0/24"
  next_hop         = "172.16.10.201"
}
#Медведково
resource "vkcs_networking_subnet_route" "route-contol-zone2" {
  subnet_id        = vkcs_networking_subnet.control-subnet.id
  destination_cidr = "172.16.200.0/24"
  next_hop         = "172.16.10.202"
}

#Коровинское
resource "vkcs_networking_subnet_route" "route-contol-zone3" {
  subnet_id        = vkcs_networking_subnet.control-subnet.id
  destination_cidr = "172.16.0.0/24"
  next_hop         = "172.16.10.203"
}

#К БД
resource "vkcs_networking_subnet_route" "route-contol-db" {
  subnet_id        = vkcs_networking_subnet.control-subnet.id
  destination_cidr = "172.16.50.0/24"
  next_hop         = "172.16.10.1"
}