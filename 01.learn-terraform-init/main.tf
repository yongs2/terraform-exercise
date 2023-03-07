# Configure the docker provider
provider "docker" {
}

provider "random" {
}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

# Create a docker container resource
# -> same as 'docker run --name nginx -p8080:80 -d nginx:latest'
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "hello-terraform"
  ports {
    internal = 80
    external = 8000
  }
}

resource "random_pet" "dog" {
  length = 2
}

module "nginx-pet" {
  source = "./nginx"

  container_name = "hello-${random_pet.dog.id}"
  nginx_port     = 8001
}

# https://registry.terraform.io/modules/joatmon08/hello/random/latest
# https://github.com/joatmon08/terraform-random-hello/blob/3.0.1/random.tf
module "hello" {
  source  = "joatmon08/hello/random"
  version = "3.0.1"

  hello = random_pet.dog.id

  secret_key = "secret"
}
