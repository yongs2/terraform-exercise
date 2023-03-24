data "template_file" "installation" {
  depends_on = [
    openstack_compute_instance_v2.k8s-master,
    openstack_compute_instance_v2.k8s-worker,
  ]

  template = templatefile("installation.sh", {
    private_key        = file("${var.ssh_key_file}")
    http_proxy         = var.http_proxy
    masterips          = join(" ", "${openstack_compute_instance_v2.k8s-master.*.access_ip_v4}") # var.master_ips
    workerips          = join(" ", "${openstack_compute_instance_v2.k8s-worker.*.access_ip_v4}") # var.worker_ips
    kube_control_hosts = var.master_vm_count                                                     # KUBE_CONTROL_HOSTS
    metallb_ip_range   = var.metallb_ip_range # for metallb
  })
}

resource "openstack_compute_instance_v2" "ansible" {
  depends_on = [
    openstack_compute_instance_v2.k8s-master,
    openstack_compute_instance_v2.k8s-worker,
  ]

  name            = "ansible"
  image_name      = var.image
  flavor_id       = openstack_compute_flavor_v2.flavor.id
  key_pair        = openstack_compute_keypair_v2.keypair.name
  security_groups = ["default"]
  # user_data       = data.template_file.installation.rendered

  network {
    name        = var.network.name
    fixed_ip_v4 = var.fixed_ip_v4[var.master_vm_count + var.worker_vm_count] # master, worker 이후의 인덱스 사용
  }

  provisioner "remote-exec" {
    inline = ["${data.template_file.installation.rendered}"]
    connection {
      type        = "ssh"
      user        = "rocky"
      private_key = file("${var.ssh_key_file}")
      host        = openstack_compute_instance_v2.ansible.access_ip_v4
    }
  }
}

output "user_data" {
  value = data.template_file.installation.rendered
}
