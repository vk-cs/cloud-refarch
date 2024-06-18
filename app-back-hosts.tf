# Экземпляры машин BACK
# Создаем порты отдельным ресурсом, так как параметр "fixed_ip_v4"
# для ресурсов "vkcs_compute_instance" корректно не работает

resource "vkcs_networking_port" "zone1-back_port" {
  network_id = vkcs_networking_network.DR_vnet.id

  name        = "zone1 Back Port"
  description = "zone1 Back Port"

  fixed_ip {
    subnet_id  = vkcs_networking_subnet.zone1-vnet100.id
    ip_address = "172.16.100.20"
  }

  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}

resource "vkcs_networking_port" "zone1-back-to-db-port" {
  network_id = vkcs_networking_network.dbcluster-net.id

  name        = "zone1 Back to Database Port"
  description = "zone1 Back to Database Port"

  fixed_ip {
    subnet_id  = vkcs_networking_subnet.dbcluster-subnet.id
    ip_address = "172.16.50.150"
  }
  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}

resource "vkcs_compute_instance" "zone1-back" {
  name               = "zone1-back"
  flavor_name        = var.back_flavor
  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
  availability_zone = var.zones["zone1"]
  #var.zones["zone1"]
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
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }

  config_drive = true

  network {
    port = vkcs_networking_port.zone1-back_port.id
  }

  network {
    port = vkcs_networking_port.zone1-back-to-db-port.id
  }
}

resource "vkcs_networking_port" "zone2-back_port" {
  network_id = vkcs_networking_network.DR_vnet.id

  name        = "zone2 Back Port"
  description = "zone2 Back Port"

  fixed_ip {
    subnet_id  = vkcs_networking_subnet.zone2-vnet200.id
    ip_address = "172.16.200.20"
  }

  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}


resource "vkcs_networking_port" "zone2-back-to-db-port" {
  network_id = vkcs_networking_network.dbcluster-net.id

  name        = "zone2 Back to Database Port"
  description = "zone2 Back to Database Port"

  fixed_ip {
    subnet_id  = vkcs_networking_subnet.dbcluster-subnet.id
    ip_address = "172.16.50.151"
  }
  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}

resource "vkcs_compute_instance" "zone2-back" {
  name               = "zone2-back"
  flavor_name        = var.back_flavor
  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
  availability_zone  = var.zones["zone2"]
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
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }

  config_drive = true

  network {
    port = vkcs_networking_port.zone2-back_port.id
  }

  network {
    port = vkcs_networking_port.zone2-back-to-db-port.id
  }
}

resource "vkcs_networking_port" "zone3-back_port" {
  network_id = vkcs_networking_network.DR_vnet.id

  name        = "zone3 Back Port"
  description = "zone3 Back Port"

  fixed_ip {
    subnet_id  = vkcs_networking_subnet.zone3-vnet000.id
    ip_address = "172.16.0.20"
  }

  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}

resource "vkcs_networking_port" "zone3-back-to-db-port" {
  network_id = vkcs_networking_network.dbcluster-net.id

  name        = "zone3 Back to Database Port"
  description = "zone3 Back to Database Port"

  fixed_ip {
    subnet_id  = vkcs_networking_subnet.dbcluster-subnet.id
    ip_address = "172.16.50.152"
  }
  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}

resource "vkcs_compute_instance" "zone3-back" {
  name               = "zone3-back"
  flavor_name        = var.back_flavor
  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
  availability_zone  = var.zones["zone3"]
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
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }

  config_drive = true

  network {
    port = vkcs_networking_port.zone3-back_port.id
  }

  network {
    port = vkcs_networking_port.zone3-back-to-db-port.id
  }
}
