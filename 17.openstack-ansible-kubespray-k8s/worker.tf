# openstack server list; openstack server show k8s-worker
resource "openstack_compute_instance_v2" "k8s-worker" {
  count           = var.worker_vm_count
  name            = format("k8s-worker-%02d", count.index + 1)
  image_name      = var.image
  flavor_id       = openstack_compute_flavor_v2.flavor.id
  key_pair        = openstack_compute_keypair_v2.keypair.name
  security_groups = ["default"]

  network {
    name        = var.network.name
    fixed_ip_v4 = var.fixed_ip_v4[var.master_vm_count + count.index] # master 이후의 인덱스 사용
  }
}

output "worker_ips" {
  value = join(" ", "${openstack_compute_instance_v2.k8s-worker.*.access_ip_v4}")
}
