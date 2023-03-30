# k8s-master 에서 rocky 계정으로 kubectl 실행하기 위한 설정
resource "null_resource" "kube_config_for_rocky" {
  count = var.master_vm_count

  # make /home/rocky/.kube/config
  provisioner "remote-exec" {
    scripts = [
      "${path.module}/install.sh",
    ]

    connection {
      type        = "ssh"
      user        = "rocky"
      private_key = var.private_key
      host        = var.master_ips[count.index]
    }
  }

  # make local file kubeconfig
  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null rocky@${var.master_ips[count.index]}:/home/rocky/.kube/config ${path.module}/${format("k8s-master-%02d", count.index + 1)}.kubeconfig"
  }
}
