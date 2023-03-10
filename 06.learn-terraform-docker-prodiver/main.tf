provider "docker" {
  registry_auth {
    username = var.registry_auth.username
    password = var.registry_auth.password
    address = var.registry_auth.address
  }
}

# Create a docker image resource
# -> docker pull var.registry_auth.address/centos:centos7.9.2009
resource "docker_image" "centos7" {
  provider = docker
  name     = "${var.registry_auth.address}/centos:centos7.9.2009"
}

# Create a docker image resource
# -> docker pull var.registry_auth.address/centos:centos8.4.2105
resource "docker_image" "centos8" {
  provider = docker
  name     = "${var.registry_auth.address}/centos:centos8.4.2105"
}
