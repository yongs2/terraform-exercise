## Output value definitions

output "nginx_hosts" {
  value = {
    name : docker_container.nginx.name,
    host : "${docker_container.nginx.ports[0].ip}:${docker_container.nginx.ports[0].external}"
  }
}
