# Refer to https://github.com/jacobbaek/terraform-openstack

# Define required providers
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "~> 3.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0.0"
    }
  }
}
