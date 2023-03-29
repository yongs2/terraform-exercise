provider "docker" {
  alias = "test"

  # host = "ssh://root@localhost:32822"
}

resource "docker_image" "test" {
  provider = docker.test
  name     = "busybox:latest"
}
