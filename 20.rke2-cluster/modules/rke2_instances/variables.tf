## Input variable definitions

variable "image" {
  default = "Rocky-8-GenericCloud-8.7"
}

variable "private_key" {
  type = string
}

# openstack availability zone list
variable "availability_zone_name" {
  default = "server2"
}

variable "instance_prefix" {
  default = "rke2-instance"
}

# openstack network list
variable "network_name" {
  type = string
}

# openstack subnet list
variable "subnet_name" {
  type = string
}

variable "flavor_id" {
  type = string
}

variable "key_pair" {
  type = string
}

variable "vm_count" {
  type = number
}

variable "fixed_ip_v4" {
  type = list(string)
}

# The list of IP addresses to be used by metallb must also be set in the allowed_address_pairs of the openstack port.
variable "allowed_address_pairs" {
  type = list(string)
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
