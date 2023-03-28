provider "openstack" {}

# openstack flavor list; openstack flavor show C2M2D20
resource "openstack_compute_flavor_v2" "ansible-flavor" {
  name  = "C2M2D20"
  ram   = "2048"
  vcpus = "2"
  disk  = "20"
}

resource "openstack_compute_flavor_v2" "k8s-flavor" {
  name  = "C2M8D20"
  ram   = "8192"
  vcpus = "2"
  disk  = "20"
}

# openstack keypair list; openstack keypair show "${var.instance_prefix}-keypair"
resource "openstack_compute_keypair_v2" "keypair" {
  name       = "${var.instance_prefix}-keypair"
  public_key = file("${var.ssh_key_file}.pub")
}
