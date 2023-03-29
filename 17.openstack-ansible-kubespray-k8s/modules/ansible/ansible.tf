data "template_file" "installation" {
  template = templatefile("${path.module}/installation.sh", {
    private_key        = var.private_key
    http_proxy         = var.http_proxy
    masterips          = var.master_ips
    workerips          = var.worker_ips
    kube_control_hosts = length(split(" ", var.master_ips)) # KUBE_CONTROL_HOSTS, convert to array and count
    metallb_ip_range   = var.metallb_ip_range               # for metallb
    kubespray_version  = var.kubespray_version
  })
}

resource "openstack_compute_instance_v2" "ansible" {
  name            = "ansible"
  image_name      = var.image
  flavor_id       = var.flavor_id
  key_pair        = var.key_pair
  security_groups = ["default"]

  network {
    name        = var.network_name
    fixed_ip_v4 = var.fixed_ip_v4
  }

  provisioner "remote-exec" {
    inline = ["${data.template_file.installation.rendered}"]
    connection {
      type        = "ssh"
      user        = "rocky"
      private_key = var.private_key
      host        = openstack_compute_instance_v2.ansible.access_ip_v4
    }
  }
}

output "user_data" {
  value = data.template_file.installation.rendered
}
