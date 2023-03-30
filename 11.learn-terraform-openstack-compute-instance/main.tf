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

# openstack network show management --format=json | jq '.id'
data "openstack_networking_network_v2" "basic" {
  name = var.network_name
}

data "openstack_networking_subnet_v2" "basic" {
  name       = var.subnet_name
}

# openstack port show basic --format=json | jq '.allowed_address_pairs'
resource "openstack_networking_port_v2" "basic" {
  name           = "basic"
  network_id     = data.openstack_networking_network_v2.basic.id
  admin_state_up = "true"
  
  fixed_ip {
    subnet_id  = data.openstack_networking_subnet_v2.basic.id
    ip_address = var.fixed_ip_v4
  }

  dynamic "allowed_address_pairs" {
    for_each = var.allowed_address_pairs
    content {
      ip_address = allowed_address_pairs.value
    }
  }
}

# openstack server list; openstack server show basic
resource "openstack_compute_instance_v2" "basic" {
  name            = "basic"
  image_name      = var.image
  flavor_id       = openstack_compute_flavor_v2.C1M2D20.id
  key_pair        = openstack_compute_keypair_v2.basic.name
  security_groups = ["default"]

  network {
    name = var.network_name
    port        = openstack_networking_port_v2.basic.id
  }
}
