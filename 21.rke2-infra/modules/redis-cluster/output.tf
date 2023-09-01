## Output value definitions

output "deployment_values" {
  value = rancher2_app_v2.redis-cluster.deployment_values
}

output "values" {
  value = data.template_file.values.rendered
}
