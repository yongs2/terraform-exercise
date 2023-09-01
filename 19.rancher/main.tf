provider "openstack" {}

# openstack flavor list; openstack flavor show C2M8D40
resource "openstack_compute_flavor_v2" "C2M8D40" {
  name  = "C2M8D40"
  vcpus = "2"
  ram   = "8192"
  disk  = "40"
}

# openstack keypair list; openstack keypair show rancher
resource "openstack_compute_keypair_v2" "rancher" {
  name       = "rancher"
  public_key = file("${var.ssh_key_file}.pub")
}

# openstack network show management --format=json | jq '.id'
data "openstack_networking_network_v2" "rancher" {
  name = var.network_name
}

data "openstack_networking_subnet_v2" "rancher" {
  name = var.subnet_name
}

# openstack port show rancher --format=json | jq '.allowed_address_pairs'
resource "openstack_networking_port_v2" "rancher" {
  name           = "rancher"
  network_id     = data.openstack_networking_network_v2.rancher.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id  = data.openstack_networking_subnet_v2.rancher.id
    ip_address = var.fixed_ip_v4
  }

  dynamic "allowed_address_pairs" {
    for_each = var.allowed_address_pairs
    content {
      ip_address = allowed_address_pairs.value
    }
  }
}

# openstack server list; openstack server show rancher
resource "openstack_compute_instance_v2" "rancher" {
  name            = "rancher"
  image_name      = var.image
  flavor_id       = openstack_compute_flavor_v2.C2M8D40.id
  key_pair        = openstack_compute_keypair_v2.rancher.name
  security_groups = ["default"]

  network {
    name = var.network_name
    port = openstack_networking_port_v2.rancher.id
  }
}

# install docker & docker run rancher
resource "null_resource" "install_docker_run_rancher" {
  depends_on = [openstack_compute_instance_v2.rancher]

  provisioner "remote-exec" {
    scripts = [
      "./bin/01_install.sh",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.ssh_key_file}")
      host        = openstack_compute_instance_v2.rancher.access_ip_v4
    }
  }
}
