## Output value definitions

output "image_centos7" {
  description = "ID of the Docker image"
  value = {
    id : docker_image.centos7.id
    name : docker_image.centos7.name
  }
}

output "image_centos8" {
  description = "ID of the Docker image"
  value       = {
    id: docker_image.centos8.id
    name: docker_image.centos8.name
  }
}