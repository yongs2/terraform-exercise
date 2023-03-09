## Output value definitions

output "nginx_hosts" {
  value = {
    name : docker_container.nginx.name,
    host : "${docker_container.nginx.ports[0].ip}:${docker_container.nginx.ports[0].external}"
  }
}

output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.nginx.id
}

output "image_id" {
  description = "ID of the Docker image"
  value       = docker_image.nginx.id
}
