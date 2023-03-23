# k8s-master 에서 rocky 계정으로 kubectl 실행하기 위한 설정
resource "null_resource" "kube_config_for_rocky" {
  depends_on = [
    openstack_compute_instance_v2.k8s-master,
    openstack_compute_instance_v2.k8s-worker,
    openstack_compute_instance_v2.ansible,
  ]

  count = var.master_vm_count # master 에서만 수행

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/rocky/.kube",
      "sudo cp -i /etc/kubernetes/admin.conf /home/rocky/.kube/config",
      "sudo chown $(id -u):$(id -g) /home/rocky/.kube/config",
      "sed -i 's/127.0.0.1/'$(hostname -i)'/g' /home/rocky/.kube/config",
      "kubectl get nodes",
    ]

    connection {
      type        = "ssh"
      user        = "rocky"
      private_key = file("${var.ssh_key_file}")
      host        = openstack_compute_instance_v2.k8s-master[count.index].access_ip_v4
    }
  }
}
