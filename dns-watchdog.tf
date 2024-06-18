resource "vkcs_networking_port" "zone1-dns-wd-port" {
  network_id = vkcs_networking_network.DR_vnet.id

  fixed_ip {
    subnet_id  = vkcs_networking_subnet.control-subnet.id
    ip_address = "172.16.10.30"
  }

  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}

resource "vkcs_compute_instance" "zone1-dns-watchdog" {
  name               = "zone1-dns-watchdog"
  flavor_name        = var.dns_wd_flavor
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
    port = vkcs_networking_port.zone1-dns-wd-port.id
  }
}

resource "vkcs_networking_port" "zone2-dns-wd-port" {
  network_id = vkcs_networking_network.DR_vnet.id

  fixed_ip {
    subnet_id  = vkcs_networking_subnet.control-subnet.id
    ip_address = "172.16.10.31"
  }

  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}

resource "vkcs_compute_instance" "zone2-dns-watchdog" {
  name               = "zone2-dns-watchdog"
  flavor_name        = var.dns_wd_flavor
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
    port = vkcs_networking_port.zone2-dns-wd-port.id
  }
}

resource "vkcs_networking_port" "zone3-dns-wd-port" {
  network_id = vkcs_networking_network.DR_vnet.id

  fixed_ip {
    subnet_id  = vkcs_networking_subnet.control-subnet.id
    ip_address = "172.16.10.32"
  }

  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}

resource "vkcs_compute_instance" "zone3-dns-watchdog" {
  name               = "zone3-dns-watchdog"
  flavor_name        = var.dns_wd_flavor
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
    port = vkcs_networking_port.zone3-dns-wd-port.id
  }
}
