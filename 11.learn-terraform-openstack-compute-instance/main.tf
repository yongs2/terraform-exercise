provider "openstack" {}

# openstack flavor list; openstack flavor show C1M2D20
resource "openstack_compute_flavor_v2" "C1M2D20" {
  name  = "C1M2D20"
  ram   = "2048"
  vcpus = "1"
  disk  = "20"
  swap  = "4096"
}

# openstack keypair list; openstack keypair show basic
resource "openstack_compute_keypair_v2" "basic" {
  name       = "basic"
  public_key = file("${var.ssh_key_file}.pub")
}

# openstack server list; openstack server show basic
resource "openstack_compute_instance_v2" "basic" {
  name            = "basic"
  image_name      = var.image
  flavor_id       = openstack_compute_flavor_v2.C1M2D20.id
  key_pair        = openstack_compute_keypair_v2.basic.name
  security_groups = ["default"]

  metadata = {
    this = "that"
  }

  network {
    name = var.network_name
  }
}
