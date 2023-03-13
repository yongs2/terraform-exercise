## Output value definitions

output "mariadb_instance_manifest" {
  value = data.helm_template.mariadb_instance.manifest
}

output "mariadb_instance_notes" {
  value = data.helm_template.mariadb_instance.notes
}
