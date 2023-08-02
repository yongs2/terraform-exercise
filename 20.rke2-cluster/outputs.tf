## Output value definitions

output "vm_ips" {
  value = module.rke2_instances.vm_ips
}

output "rancher2_cluster_v2" {
  sensitive = true
  value     = module.rke2_server.rancher2_cluster_v2
}

output "script_install" {
  sensitive = true
  value     = module.rke2_server.script_install
}

output "script_install_registries" {
  sensitive = true
  value     = module.rke2_server.script_install_registries
}