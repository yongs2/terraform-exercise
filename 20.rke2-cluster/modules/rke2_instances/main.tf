# openstack network show management --format=json | jq '.id'
data "openstack_networking_network_v2" "rke2-instance" {
  name = var.network_name
}

# openstack subnet show management --format json
data "openstack_networking_subnet_v2" "rke2-instance" {
  name = var.subnet_name
}

# openstack port show rke2-instance --format=json | jq '.allowed_address_pairs'
resource "openstack_networking_port_v2" "rke2-instance" {
  count          = var.vm_count
  name           = format("${var.instance_prefix}-%02d", count.index + 1)
  network_id     = data.openstack_networking_network_v2.rke2-instance.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id  = data.openstack_networking_subnet_v2.rke2-instance.id
    ip_address = var.fixed_ip_v4[count.index] # 0번째 인덱스에는 master 노드의 ip 가 저장되어 있음
  }

  dynamic "allowed_address_pairs" {
    for_each = var.allowed_address_pairs
    content {
      ip_address = allowed_address_pairs.value
    }
  }
}

# openstack server list; openstack server show rke2-instance
resource "openstack_compute_instance_v2" "rke2-instance" {
  count           = var.vm_count
  name            = format("${var.instance_prefix}-%02d", count.index + 1)
  image_name      = var.image
  flavor_id       = var.flavor_id
  key_pair        = var.key_pair
  security_groups = ["default"]

  network {
    name = var.network_name
    port = openstack_networking_port_v2.rke2-instance[count.index].id
  }
}

# install_etcd_hosts.sh 템플릿을 생성하는 데이터 소스 정의
data "template_file" "install_etcd_hosts" {
  depends_on = [openstack_compute_instance_v2.rke2-instance]
  template = templatefile("${path.module}/install_etcd_hosts.sh.tpl", {
    hosts = [for index, ipaddr in var.fixed_ip_v4 : {
      name = format("${var.instance_prefix}-%02d.novalocal", index + 1),
      ip   = ipaddr
    }]
  })
}

# install_etcd_hosts.sh 파일 생성
resource "local_file" "install_etcd_hosts" {
  depends_on = [data.template_file.install_etcd_hosts]
  filename   = "${path.module}/install_etcd_hosts.sh"
  content    = data.template_file.install_etcd_hosts.rendered
}

# install script
resource "null_resource" "install" {
  depends_on = [
    openstack_compute_instance_v2.rke2-instance,
    local_file.install_etcd_hosts
  ]

  count = var.vm_count

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/install.sh",
      "${path.module}/install_etcd_hosts.sh",
    ]

    connection {
      type        = "ssh"
      user        = "rocky"
      private_key = var.private_key
      host        = openstack_compute_instance_v2.rke2-instance[count.index].access_ip_v4
    }
  }
}
