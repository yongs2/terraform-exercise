## Input variable definitions

variable "image" {
  default = "Rocky-8-GenericCloud-8.7"
}

variable "ssh_key_file" {
  default = "~/.ssh/id_rsa"
}

# openstack availability zone list
variable "availability_zone_name" {
  default = "server2"
}

# openstack network list
variable "network" {
  type = object({
    name = string
  })
  default = {
    name = "management"
  }
}

# openstack subnet list
variable "subnet" {
  type = object({
    name = string
  })
  default = {
    name = "management"
  }
}

variable "instance_prefix" {
  default = "rke2-node"
}

variable "vm_count" {
  type    = number
  default = 3
}

variable "fixed_ip_v4" {
  type = list(string)
  default = [
    "192.168.5.59", // rke2-dev-001
    "192.168.5.60", // rke2-dev-002
    "192.168.5.63", // rke2-dev-003
    # "192.168.5.64", // metallb_ip_range
    # "192.168.5.65", // metallb_ip_range
    # "192.168.5.66" // metallb_ip_range
  ]
}

# The list of IP addresses to be used by metallb must also be set in the allowed_address_pairs of the openstack port.
variable "allowed_address_pairs" {
  type = list(string)
  default = [
    "192.168.5.64",
    "192.168.5.65",
    "192.168.5.66"
  ]
}

# private docker registry
variable "reg-nef-ci" {
  type = object({
    name                 = string
    endpoint             = string
    username             = string
    password             = string
    insecure_skip_verify = bool
  })
  default = {
    name                 = "nef-ci.com:5005"
    endpoint             = "https://nef-ci.com:5005"
    username             = "root"
    password             = "ntels1234"
    insecure_skip_verify = true
  }
}

variable "reg-nexus" {
  type = object({
    name                 = string
    endpoint             = string
    username             = string
    password             = string
    insecure_skip_verify = bool
  })
  default = {
    name                 = "192.168.5.69:5000"
    endpoint             = "http://192.168.5.69:5000"
    username             = "admin"
    password             = "ntels1234"
    insecure_skip_verify = true
  }
}

variable "private_container_registries" {
  description = "private_container_registries"
  type = list(object({
    name                 = string
    endpoint             = string
    username             = string
    password             = string
    insecure_skip_verify = bool
  }))
  default = []
}

variable "rancher2_api_endpoint" {
  default = ""
}

variable "rancher2_access_key" {
  default = ""
}

variable "rancher2_secret_key" {
  default = ""
}

variable "kube_config_path" {
  default = "/tmp/rke2-dev.kubeconfig"
}
