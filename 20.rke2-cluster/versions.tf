# Refer to https://github.com/jacobbaek/terraform-openstack

# Define required providers
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.50.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "~> 3.0.0"
    }
  }
}
