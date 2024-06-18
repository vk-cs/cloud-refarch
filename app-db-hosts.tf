# Экземпляры машин кластера Patroni
# Создаем порты отдельным ресурсом, так как параметр "fixed_ip_v4"
# для ресурсов "vkcs_compute_instance" корректно не работает

# Резервиуем адрес для виртуального IP кластера БД
resource "vkcs_networking_port" "vip-db" {
  name           = "Database cluster VIP"
  network_id     = vkcs_networking_network.dbcluster-net.id
  description    = "DO NOT CONNECT ANYWHERE!!!"
  admin_state_up = false
  fixed_ip {
    subnet_id  = vkcs_networking_subnet.dbcluster-subnet.id
    ip_address = "172.16.50.123"
  }
}

# Разрешаем виртуальный IP на портах серверов БД
resource "vkcs_networking_port" "zone1-db-port" {
  name        = "zone1 Database Port"
  network_id  = vkcs_networking_network.dbcluster-net.id
  description = "zone1 Database port"
  fixed_ip {
    subnet_id  = vkcs_networking_subnet.dbcluster-subnet.id
    ip_address = "172.16.50.100"
  }
  allowed_address_pairs {
    ip_address = "172.16.50.123"
  }
  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}

resource "vkcs_networking_port" "zone2-db-port" {
  name        = "zone2 Database Port"
  network_id  = vkcs_networking_network.dbcluster-net.id
  description = "zone2 Database port"
  fixed_ip {
    subnet_id  = vkcs_networking_subnet.dbcluster-subnet.id
    ip_address = "172.16.50.101"
  }
  allowed_address_pairs {
    ip_address = "172.16.50.123"
  }
  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}

resource "vkcs_networking_port" "zone3-db-port" {
  name        = "zone3 Database Port"
  network_id  = vkcs_networking_network.dbcluster-net.id
  description = "zone3 Database port"
  fixed_ip {
    subnet_id  = vkcs_networking_subnet.dbcluster-subnet.id
    ip_address = "172.16.50.102"
  }
  allowed_address_pairs {
    ip_address = "172.16.50.123"
  }
  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}

resource "vkcs_compute_instance" "zone1-db" {
  name              = "zone1-db"
  flavor_name       = var.db_flavor
  availability_zone =  var.zones["zone1"]
  key_pair          = var.key_pair_name
  tags = ["reference_arch"]
  metadata = {
    sid = "reference_arch"
  }

  block_device {
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    uuid                  = data.vkcs_images_image.ubuntu.id
    volume_size           = 35
    boot_index            = 0
    delete_on_termination = true
  }

  config_drive = true

  network {
    port = vkcs_networking_port.zone1-db-port.id
  }
}

resource "vkcs_compute_instance" "zone2-db" {
  name               = "zone2-db"
  flavor_name        = var.db_flavor
  availability_zone  = var.zones["zone2"]
  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
  key_pair           = var.key_pair_name
  tags = ["reference_arch"]
   metadata = {
    sid = "reference_arch"
  }

  block_device {
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    uuid                  = data.vkcs_images_image.ubuntu.id
    volume_size           = 35
    boot_index            = 0
    delete_on_termination = true
  }

  config_drive = true

  network {
    port = vkcs_networking_port.zone2-db-port.id
  }
}

resource "vkcs_compute_instance" "zone3-db" {
  name               = "zone3-db"
  flavor_name        = var.db_flavor
  availability_zone  = var.zones["zone3"]
  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
  key_pair           = var.key_pair_name
  tags = ["reference_arch"]
  metadata = {
    sid = "reference_arch"
  }

  block_device {
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    uuid                  = data.vkcs_images_image.ubuntu.id
    volume_size           = 35
    boot_index            = 0
    delete_on_termination = true
  }

  config_drive = true

  network {
    port = vkcs_networking_port.zone3-db-port.id
  }
}