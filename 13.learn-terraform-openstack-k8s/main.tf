provider "openstack" {}

# openstack flavor list; openstack flavor show C2M2D20
resource "openstack_compute_flavor_v2" "flavor" {
  name  = "C2M2D20"
  ram   = "2048"
  vcpus = "2"
  disk  = "20"
}

# openstack keypair list; openstack keypair show "${var.instance_prefix}-keypair"
resource "openstack_compute_keypair_v2" "keypair" {
  name       = "${var.instance_prefix}-keypair"
  public_key = file("${var.ssh_key_file}.pub")
}

# openstack server list; openstack server show master
resource "openstack_compute_instance_v2" "master" {
  count      = 1
  name       = format("${var.instance_prefix}-%02d", count.index + 1)
  image_name = var.image
  flavor_id  = openstack_compute_flavor_v2.flavor.id
  key_pair   = openstack_compute_keypair_v2.keypair.name
  security_groups = ["default"]

  network {
    name        = var.network_name
    fixed_ip_v4 = var.fixed_ip_v4[count.index] # 0번째 인덱스에는 master 노드의 ip 가 저장되어 있음
  }
}

# openstack server list; openstack server show worker
resource "openstack_compute_instance_v2" "worker" {
  depends_on = [openstack_compute_instance_v2.master] # master 생성 후 worker 를 생성하도록

  count      = var.instance_count - 1 # master 를 제외한 worker 노드의 수
  name       = format("${var.instance_prefix}-%02d", count.index + 2)
  image_name = var.image
  flavor_id  = openstack_compute_flavor_v2.flavor.id
  key_pair   = openstack_compute_keypair_v2.keypair.name
  security_groups = ["default"]

  network {
    name        = var.network_name
    fixed_ip_v4 = var.fixed_ip_v4[count.index + 1] # 1번째 인덱스부터 worker 노드의 ip 가 저장되어 있음
  }
}

# Kubernetes 설치 - master
resource "null_resource" "install_kuberernetes_master" {
  depends_on = [openstack_compute_instance_v2.master]

  count           = 1

  provisioner "remote-exec" {
    scripts = [
      "./bin/01_install.sh",
      "./bin/02_kubeadm_init.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.ssh_key_file}")
      host        = openstack_compute_instance_v2.master[0].access_ip_v4
    }
  }

  provisioner "local-exec" {
    command = <<EOF
      rm -rvf ./bin/03_kubeadm_join.sh
      echo "echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward" > ./bin/03_kubeadm_join.sh
      export KUBE_JOIN_CMD=$(ssh ubuntu@${openstack_compute_instance_v2.master[0].access_ip_v4} -o StrictHostKeyChecking=no -i ${var.ssh_key_file} "kubeadm token create --print-join-command") >> ./bin/03_kubeadm_join.sh
      echo "sudo $KUBE_JOIN_CMD">> ./bin/03_kubeadm_join.sh
    EOF
  }
}


# kubernetes 설치 - worker
resource "null_resource" "install_kubernetes_worker" {
  depends_on = [
    openstack_compute_instance_v2.master,
    openstack_compute_instance_v2.worker,
    null_resource.install_kuberernetes_master,
  ]

  count = var.instance_count - 1 # master 를 제외한 worker 노드의 수

  provisioner "remote-exec" {
    scripts = [
      "./bin/01_install.sh",
      "./bin/03_kubeadm_join.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.ssh_key_file}")
      host        = openstack_compute_instance_v2.worker[count.index].access_ip_v4
    }
  }
}
