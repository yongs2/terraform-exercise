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

# openstack server list; openstack server show basenode
resource "openstack_compute_instance_v2" "basenode" {
  name       = format("${var.instance_prefix}-%02d", 1)
  image_name = var.image
  flavor_id  = openstack_compute_flavor_v2.flavor.id
  key_pair   = openstack_compute_keypair_v2.keypair.name
  security_groups = ["default"]

  network {
    name        = var.network_name
    fixed_ip_v4 = var.fixed_ip_v4
  }
}

# Kubernetes 설치 - basenode
resource "null_resource" "install_kuberernetes_basenode" {
  depends_on = [openstack_compute_instance_v2.basenode]

  provisioner "remote-exec" {
    scripts = [
      "./bin/01_install.sh",
    ]

    connection {
      type        = "ssh"
      user        = "rocky"
      private_key = file("${var.ssh_key_file}")
      host        = openstack_compute_instance_v2.basenode.access_ip_v4
    }
  }
}

# 스냅샷 촬영 및 이미지 생성을 수행하는 null_resource
resource "null_resource" "snapshot_and_create_image" {
  # VM이 생성된 후에 실행됩니다.
  depends_on = [
    openstack_compute_instance_v2.basenode,
    null_resource.install_kuberernetes_basenode,
  ]

  triggers = {
    instance_id = openstack_compute_instance_v2.basenode.id
  }

  # 스냅샷 촬영과 이미지 생성을 위한 스크립트
  provisioner "local-exec" {
    command = <<EOF
      pwd && ls -la
      source /workspace/.openstack.profile
      mkdir -p /workspace/tmp
      
      # 이전 생성 이미지 삭제
      openstack image delete ${var.snapshot} && echo "delete old image ${var.snapshot}"
      
      # 스냅샷 촬영
      echo "snapshot.instance.id: [${openstack_compute_instance_v2.basenode.id}]"
      openstack server image create --name ${var.snapshot} ${openstack_compute_instance_v2.basenode.id}
      
      # 이미지가 저장될 때까지 대기하기
      while true; do
        openstack image show -f value -c status "${var.snapshot}" > status.log
        echo "image status: [$(cat status.log)]"
        if [[ $(cat status.log) == "active" ]]; then
          break
        fi
        sleep 5
      done
    EOF
  }
}
