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

# openstack network list
variable "network_name" {
  type = string
}

variable "flavor_id" {
  type = string
}

variable "key_pair" {
  type = string
}

variable "master_vm_count" {
  type = number
}

variable "worker_vm_count" {
  type = number
}

variable "fixed_ip_v4" {
  type = list(string)
}
