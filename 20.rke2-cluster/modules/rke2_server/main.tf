# Create a new rancher v2 RKE2 custom Cluster v2
resource "rancher2_cluster_v2" "rke2-dev" {
  name               = var.cluster_name
  kubernetes_version = "v1.26.6+rke2r1"
  rke_config {
    machine_global_config = <<EOF
cni: "calico"
kube-proxy-arg:
  - proxy-mode=ipvs
  - ipvs-strict-arp=true
EOF
  }
}

# install system-agent-install.sh
data "template_file" "install" {
  depends_on = [rancher2_cluster_v2.rke2-dev]

  template = templatefile("${path.module}/install.sh.tpl", {
    insecure_node_command = rancher2_cluster_v2.rke2-dev.cluster_registration_token[0].insecure_node_command
  })
}

# install.sh 파일 생성
resource "local_file" "install" {
  depends_on = [data.template_file.install]
  filename   = "${path.module}/install.sh"
  content    = data.template_file.install.rendered
}

# install_registries.sh 템플릿을 생성하는 데이터 소스 정의
data "template_file" "install_registries" {
  depends_on = [rancher2_cluster_v2.rke2-dev]

  template = templatefile("${path.module}/install_registries.sh.tpl", {
    private_container_registries = [for index, registry in var.private_container_registries : {
      name                 = registry.name,
      endpoint             = registry.endpoint,
      username             = registry.username,
      password             = registry.password,
      insecure_skip_verify = registry.insecure_skip_verify,
    }]
  })
}

# install_registries.sh 파일 생성
resource "local_file" "install_registries" {
  depends_on = [data.template_file.install_registries]
  filename   = "${path.module}/install_registries.sh"
  content    = data.template_file.install_registries.rendered
}

# run script in rke2-instances
resource "null_resource" "install" {
  depends_on = [
    local_file.install,
    local_file.install_registries
  ]

  count = var.vm_count

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/install.sh",
      "${path.module}/install_registries.sh",
    ]

    connection {
      type        = "ssh"
      user        = "rocky"
      private_key = var.private_key
      host        = var.fixed_ip_v4[count.index]
    }
  }
}

resource "local_file" "rke2-dev" {
  content  = rancher2_cluster_v2.rke2-dev.kube_config
  filename = var.kube_config_path
}
