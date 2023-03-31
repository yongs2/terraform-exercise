# openstack network show management --format=json | jq '.id'
data "openstack_networking_network_v2" "k8s-master" {
  name = var.network_name
}

data "openstack_networking_subnet_v2" "k8s-master" {
  name = var.subnet_name
}

# openstack port show k8s-master --format=json | jq '.allowed_address_pairs'
resource "openstack_networking_port_v2" "k8s-master" {
  count          = var.master_vm_count
  name           = format("k8s-master-%02d", count.index + 1)
  network_id     = data.openstack_networking_network_v2.k8s-master.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id  = data.openstack_networking_subnet_v2.k8s-master.id
    ip_address = var.fixed_ip_v4[count.index] # 0번째 인덱스에는 master 노드의 ip 가 저장되어 있음
  }

  dynamic "allowed_address_pairs" {
    for_each = var.allowed_address_pairs
    content {
      ip_address = allowed_address_pairs.value
    }
  }
}

# openstack server list; openstack server show k8s-master
resource "openstack_compute_instance_v2" "k8s-master" {
  count           = var.master_vm_count
  name            = format("k8s-master-%02d", count.index + 1)
  image_name      = var.image
  flavor_id       = var.flavor_id
  key_pair        = var.key_pair
  security_groups = ["default"]

  network {
    name = var.network_name
    port = openstack_networking_port_v2.k8s-master[count.index].id
  }
}

# install sctp
resource "null_resource" "install_sctp_master" {
  depends_on = [openstack_compute_instance_v2.k8s-master]

  count = var.master_vm_count

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/install.sh",
    ]

    connection {
      type        = "ssh"
      user        = "rocky"
      private_key = var.private_key
      host        = openstack_compute_instance_v2.k8s-master[count.index].access_ip_v4
    }
  }
}

output "master_ips" {
  value = join(" ", "${openstack_compute_instance_v2.k8s-master.*.access_ip_v4}")
}
