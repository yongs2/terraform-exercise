## Output value definitions

output "deployment_values" {
  value = rancher2_app_v2.istio.deployment_values
}

output "values" {
  value = data.template_file.values.rendered
}
