# Машина для управления из Интернета
resource "vkcs_networking_port" "jump-host_port" {
  network_id = vkcs_networking_network.DR_vnet.id

  fixed_ip {
    subnet_id  = vkcs_networking_subnet.control-subnet.id
    ip_address = "172.16.10.2"
  }

  security_group_ids = [vkcs_networking_secgroup.interconnect.id]
}

resource "vkcs_compute_instance" "jump-host" {
  name               = "jump-host"
  flavor_name        = "STD3-2-4"
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
    volume_size           = 13
    boot_index            = 0
    delete_on_termination = true
  }
  # Подключаемся к сети управления
  network {
    port = vkcs_networking_port.jump-host_port.id
  }
  
  config_drive = true

}

#Внешний IP для машины управления (джамп хоста)
resource "vkcs_networking_floatingip" "control_ip" {
  pool = "internet"
  sdn  = "sprut"
}

# Назначаем внешний плавающий IPs
resource "vkcs_compute_floatingip_associate" "control_fip" {
  floating_ip = vkcs_networking_floatingip.control_ip.address
  instance_id = vkcs_compute_instance.jump-host.id
}