provider "docker" {}

provider "random" {}

provider "time" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "random_pet" "nginx" {
  length = 2
}

# Create a docker container resource
# -> same as 'docker run --name nginx -p8080:80 -d nginx:latest'
resource "docker_container" "nginx" {
  count = 4
  image = docker_image.nginx.image_id
  name  = "nginx-${random_pet.nginx.id}-${count.index}"

  ports {
    internal = 80
    external = 8000 + count.index
  }
}

resource "docker_image" "redis" {
  name         = "redis:latest"
  keep_locally = true
}

# time_sleep resource will introduce a 60 second delay between downloading the image and creating the container.
resource "time_sleep" "wait_60_seconds" {
  depends_on = [docker_image.redis]

  create_duration = "60s"
}

resource "docker_container" "data" {
  depends_on = [time_sleep.wait_60_seconds]
  image      = docker_image.redis.image_id
  name       = "data"

  ports {
    internal = 6379
    external = 6379
  }
}
