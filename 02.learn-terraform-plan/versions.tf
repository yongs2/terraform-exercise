# Set the required provider and versions
terraform {
  required_providers {
    # We recommend pinning to the specific version of the Docker Provider you're using
    # since new versions are released frequently
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
  }
}
