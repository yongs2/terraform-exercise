## Output value definitions

output "rancher2_cluster_v2" {
  sensitive = true
  # value     = rancher2_cluster_v2.rke2-dev.cluster_registration_token[0].insecure_node_command
  value = rancher2_cluster_v2.rke2-dev
}

output "script_install" {
  value = data.template_file.install.rendered
}

output "script_install_registries" {
  value = data.template_file.install_registries.rendered
}