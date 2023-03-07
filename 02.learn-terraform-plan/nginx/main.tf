# Create a docker image resource
# -> docker pull nginx:latest
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

# Create a docker container resource
# -> same as 'docker run --name nginx -p8080:80 -d nginx:latest'
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = var.container_name
  ports {
    internal = 80
    external = var.nginx_port
  }
}
