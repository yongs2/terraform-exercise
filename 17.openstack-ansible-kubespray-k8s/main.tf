provider "openstack" {}

# openstack flavor list; openstack flavor show C2M2D20
resource "openstack_compute_flavor_v2" "ansible-flavor" {
  name  = "C2M2D20"
  ram   = "2048"
  vcpus = "2"
  disk  = "20"
}

# openstack flavor list; openstack flavor show C2M8D20
resource "openstack_compute_flavor_v2" "k8s-flavor" {
  name  = "C2M8D20"
  ram   = "8192"
  vcpus = "2"
  disk  = "20"
}

# openstack keypair list; openstack keypair show "${var.instance_prefix}-keypair"
resource "openstack_compute_keypair_v2" "keypair" {
  name       = "${var.instance_prefix}-keypair"
  public_key = file("${var.ssh_key_file}.pub")
}

module "ansible" {
  source            = "./modules/ansible"
  flavor_id         = openstack_compute_flavor_v2.ansible-flavor.id
  key_pair          = openstack_compute_keypair_v2.keypair.name
  private_key       = file("${var.ssh_key_file}")
  image             = var.image
  network_name      = var.network.name
  kubespray_version = var.kubespray_version
  master_ips        = module.k8s_instances.master_ips # string
  worker_ips        = module.k8s_instances.worker_ips # string
  metallb_ip_range  = var.metallb_ip_range
  fixed_ip_v4       = var.fixed_ip_v4[var.master_vm_count + var.worker_vm_count]
}

module "k8s_instances" {
  source          = "./modules/k8s_instances"
  flavor_id       = openstack_compute_flavor_v2.k8s-flavor.id
  key_pair        = openstack_compute_keypair_v2.keypair.name
  private_key     = file("${var.ssh_key_file}")
  image           = var.image
  network_name    = var.network.name
  master_vm_count = var.master_vm_count
  worker_vm_count = var.worker_vm_count
  fixed_ip_v4     = var.fixed_ip_v4
}

module "k8s_master" {
  depends_on = [
    module.k8s_instances,
    module.ansible,
  ]

  source          = "./modules/k8s_master"
  private_key     = file("${var.ssh_key_file}")
  master_vm_count = var.master_vm_count
  master_ips      = split(" ", module.k8s_instances.master_ips) # array
}
