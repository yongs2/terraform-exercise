provider "docker" {
}

# Create a docker image resource
# -> docker pull docker:23-dind
resource "docker_image" "dind" {
  name         = "docker:23-dind"
  keep_locally = false
}

# Create a docker container resource
# -> same as 'docker run --privileged --name dind -p32822:22 -d docker:23-dind'
resource "docker_container" "dind" {
  depends_on = [
    docker_image.dind,
  ]

  name  = "dind"
  image = "docker:23-dind"

  privileged = true

  start = true

  command = ["/bin/sh", "-c",
    <<SH
    set -e
    apk --no-cache add openrc

    # setup dockerd
    apk --no-cache add docker-openrc
    echo DOCKERD_BINARY=/usr/local/bin/dockerd > /etc/conf.d/docker
    echo DOCKERD_OPTS=--host=unix:///var/run/docker.sock >> /etc/conf.d/docker
    rc-update add docker

    # link docker cli so root can see it
    ln -s /usr/local/bin/docker /usr/bin/

    # setup sshd
    apk --no-cache add openssh-server
    rc-update add sshd
    ssh-keygen -A 
    mkdir -p ~/.ssh
    /usr/sbin/sshd -D -e
    SH
    ,
  ]

  ports {
    internal = 22
    external = 32822
  }

  upload {
    content = <<AUTHORIZED_KEYS
      ${var.pub_key}
      AUTHORIZED_KEYS

    file = "/root/.ssh/authorized_keys"
  }
}