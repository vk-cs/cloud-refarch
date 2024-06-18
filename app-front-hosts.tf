# Экземпляры машин FRONT
# Создаем порты отдельным ресурсом, так как параметр "fixed_ip_v4"
# для ресурсов "vkcs_compute_instance" корректно не работает

resource "vkcs_networking_port" "zone1-front_port" {
  network_id = vkcs_networking_network.DR_vnet.id

  fixed_ip {
    subnet_id  = vkcs_networking_subnet.zone1-vnet100.id
    ip_address = "172.16.100.10"
  }

  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}

resource "vkcs_compute_instance" "zone1-front" {
  name               = "zone1-front"
  flavor_name        = var.db_flavor
  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
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
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }

  config_drive = true

  network {
    port = vkcs_networking_port.zone1-front_port.id
  }
}

resource "vkcs_networking_port" "zone2-front_port" {
  network_id = vkcs_networking_network.DR_vnet.id

  fixed_ip {
    subnet_id  = vkcs_networking_subnet.zone2-vnet200.id
    ip_address = "172.16.200.10"
  }

  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}

resource "vkcs_compute_instance" "zone2-front" {
  name               = "zone2-front"
  flavor_name        = var.db_flavor
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
    port = vkcs_networking_port.zone2-front_port.id
  }
}

resource "vkcs_networking_port" "zone3-front_port" {
  network_id = vkcs_networking_network.DR_vnet.id

  fixed_ip {
    subnet_id  = vkcs_networking_subnet.zone3-vnet000.id
    ip_address = "172.16.0.10"
  }

  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}

resource "vkcs_compute_instance" "zone3-front" {
  name               = "zone3-front"
  flavor_name        = var.db_flavor
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
    port = vkcs_networking_port.zone3-front_port.id
  }
}
