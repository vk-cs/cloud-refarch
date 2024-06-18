data "vkcs_images_image" "ubuntu" {
  visibility = "public"
  default    = true
  properties = {
    mcs_os_distro  = "ubuntu"
    mcs_os_version = "22.04"
  }
}

# data "vkcs_networking_secgroup" "ssh-www" {
#   name = "ssh+www"
# }

# resource "local_file" "ansible_inventory" {
#   content  = <<-DOC
#   jumpservers:
#     hosts:
#       ${vkcs_networking_floatingip.control_ip.address}:
#     vars:
#       ansible_user: ubuntu
#       ansible_ssh_private_key_file: ~/.ssh/${var.key_pair_name}.pem
#   DOC
#   filename = "./ansible/inventory"
# }