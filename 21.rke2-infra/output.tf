## Output value definitions

output "rancher2_cluster" {
  sensitive = true
  value     = data.rancher2_cluster.rke2-dev
}

output "rancher2_catalog_v2" {
  sensitive = true
  value     = rancher2_catalog_v2.bitnami
}

output "rancher2_project" {
  sensitive = true
  value     = data.rancher2_project.default
}

output "openebs" {
  value = module.openebs.deployment_values
}

output "metallb" {
  value = module.metallb.deployment_values
}

output "istio" {
  value = module.istio.deployment_values
}

output "etcd" {
  value = module.etcd.deployment_values
}

output "redis6" {
  value = module.redis-cluster.deployment_values
}
