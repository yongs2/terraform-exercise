provider "openstack" {}

# set config of provider rancher2
provider "rancher2" {
  # Configuration options
  api_url    = var.rancher2_api_endpoint
  access_key = var.rancher2_access_key
  secret_key = var.rancher2_secret_key
  insecure   = true
}

# openstack flavor list; openstack flavor show C4M8D40
resource "openstack_compute_flavor_v2" "rke2-flavor" {
  name  = "C4M8D40"
  vcpus = "4"
  ram   = "8192"
  disk  = "40"
}

# openstack keypair list; openstack keypair show "${var.instance_prefix}-keypair"
resource "openstack_compute_keypair_v2" "keypair" {
  name       = "${var.instance_prefix}-keypair"
  public_key = file("${var.ssh_key_file}.pub")
}

module "rke2_instances" {
  source                = "./modules/rke2_instances"
  flavor_id             = openstack_compute_flavor_v2.rke2-flavor.id
  key_pair              = openstack_compute_keypair_v2.keypair.name
  private_key           = file("${var.ssh_key_file}")
  image                 = var.image
  instance_prefix       = var.instance_prefix
  network_name          = var.network.name
  subnet_name           = var.subnet.name
  vm_count              = var.vm_count
  fixed_ip_v4           = var.fixed_ip_v4
  allowed_address_pairs = var.allowed_address_pairs
  private_container_registries = [
    var.reg-nef-ci,
    var.reg-nexus,
  ]
}

module "rke2_server" {
  depends_on = [
    module.rke2_instances,
  ]

  source          = "./modules/rke2_server"
  private_key     = file("${var.ssh_key_file}")
  cluster_name    = "rke2-dev"
  instance_prefix = var.instance_prefix
  vm_count        = var.vm_count
  fixed_ip_v4     = var.fixed_ip_v4
  private_container_registries = [
    var.reg-nef-ci,
    var.reg-nexus,
  ]
  kube_config_path = var.kube_config_path
}
