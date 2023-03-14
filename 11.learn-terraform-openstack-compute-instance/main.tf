provider "openstack" {}

# openstack keypair list; openstack keypair show basic
resource "openstack_compute_keypair_v2" "basic" {
  name       = "basic"
  public_key = file("${var.ssh_key_file}.pub")
}

# openstack server list; openstack server show basic
resource "openstack_compute_instance_v2" "basic" {
  name            = "basic"
  image_name      = var.image
  flavor_name     = var.flavor
  key_pair        = openstack_compute_keypair_v2.basic.name
  security_groups = ["default"]

  metadata = {
    this = "that"
  }

  network {
    name = var.network_name
  }
}