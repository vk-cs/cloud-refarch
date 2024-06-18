#custom secgroups workaround for default-sprut & default
resource "vkcs_networking_secgroup" "interconnect" {
  name                 = "interconnect"
  sdn                  = "sprut"
  delete_default_rules = true
}

resource "vkcs_networking_secgroup_rule" "all_in_group" {
  security_group_id = vkcs_networking_secgroup.interconnect.id
  direction         = "ingress"
}

resource "vkcs_networking_secgroup_rule" "all_eg_group" {
  security_group_id = vkcs_networking_secgroup.interconnect.id
  direction         = "egress"
}

resource "vkcs_networking_secgroup" "ssh-server" {
  name                 = "ssh-server"
  sdn                  = "sprut"
  delete_default_rules = true
}

resource "vkcs_networking_secgroup_rule" "allow-ssh" {
  security_group_id = vkcs_networking_secgroup.ssh-server.id
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = "22"
  port_range_max    = "22"
}