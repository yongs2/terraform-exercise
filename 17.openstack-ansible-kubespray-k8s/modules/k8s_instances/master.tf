# openstack server list; openstack server show k8s-master
resource "openstack_compute_instance_v2" "k8s-master" {
  count           = var.master_vm_count
  name            = format("k8s-master-%02d", count.index + 1)
  image_name      = var.image
  flavor_id       = var.flavor_id
  key_pair        = var.key_pair
  security_groups = ["default"]

  network {
    name        = var.network_name
    fixed_ip_v4 = var.fixed_ip_v4[count.index] # 0번째 인덱스에는 master 노드의 ip 가 저장되어 있음
  }
}

output "master_ips" {
  value = join(" ", "${openstack_compute_instance_v2.k8s-master.*.access_ip_v4}")
}
